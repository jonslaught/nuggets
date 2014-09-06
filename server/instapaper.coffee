
# https://github.com/codebox/reading-list-mover/blob/master/main.py
# https://github.com/randyhoyt/InstapaperOAuth/blob/master/InstapaperOAuth/InstapaperOAuth.php
# https://github.com/meteor/meteor/tree/devel/packages/oauth
# https://www.npmjs.org/package/oauth-1.0a

OAuth = Meteor.require('oauth-1.0a')

@setupInstapaper = ->
  settings = JSON.parse(Assets.getText('instapaper.json')) # config lives here
  I = new Instapaper(settings.consumer_key, settings.consumer_secret)
  I.getToken(settings.username, settings.password)
  Meteor.methods
    'callInstapaper': (endpoint, data) ->
      return I.call(endpoint, data)
  return I

class @Instapaper

  @API_PATH: 'https://www.instapaper.com/api/1.1/'

  constructor: (key, secret) ->
    @oauth = OAuth
      consumer:
        public: key
        secret: secret
        signature_method: 'HMAC-SHA1'

  call: (endpoint, data, format) ->
    
    request = 
      url: Instapaper.API_PATH + endpoint
      method: 'POST'
      data: data
    
    if @token?
      headers = @oauth.toHeader(@oauth.authorize(request, @token))
    else
      headers = @oauth.toHeader(@oauth.authorize(request))


    response = HTTP.post request.url, 
      params: request.data
      headers: headers

    content = response.content
    if format == 'qline'
      return JSON.parse('{"' + decodeURI(content.replace(/&/g, "\",\"").replace(/\=/g,"\":\"")) + '"}')
    else if format == 'html'
      return content
    else
      return JSON.parse(response.content)


  getUser: ->
    response = @call('account/verify_credentials')
    return response

  getToken: (username, password) ->

    response = @call('oauth/access_token', {
      x_auth_username: username
      x_auth_password: password
      x_auth_mode: 'client_auth'
    }, 'qline')   
    
    @token = 
      public: response.oauth_token
      secret: response.oauth_token_secret





