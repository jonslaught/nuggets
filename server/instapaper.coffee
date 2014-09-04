
# https://github.com/codebox/reading-list-mover/blob/master/main.py
# https://github.com/randyhoyt/InstapaperOAuth/blob/master/InstapaperOAuth/InstapaperOAuth.php
# https://github.com/meteor/meteor/tree/devel/packages/oauth
# https://www.npmjs.org/package/oauth-1.0a

OAuth = Meteor.require('oauth-1.0a')

Meteor.startup ->
  settings = JSON.parse(Assets.getText('instapaper.json')) # config lives here
  I = new Instapaper(settings.consumer_key, settings.consumer_secret)
  I.getToken(settings.username, settings.password)

class @Instapaper

  @API_PATH: 'https://www.instapaper.com/api/1.1/'

  constructor: (key, secret) ->
    @oauth = OAuth
      consumer:
        public: key
        secret: secret
        signature_method: 'HMAC-SHA1'

  call: (endpoint, data) ->
    request = 
      url: Instapaper.API_PATH + endpoint
      method: 'POST'
      data: data
    
    headers = @oauth.toHeader(@oauth.authorize(request))
    
    response = HTTP.post request.url, 
      params: request.data
      headers: headers

    return response.content

  getToken: (username, password) ->

    response = @call('oauth/access_token', {
      x_auth_username: username
      x_auth_password: password
      x_auth_mode: 'client_auth'
    })   
    
    parsed = JSON.parse('{"' + decodeURI(response.replace(/&/g, "\",\"").replace(/\=/g,"\":\"")) + '"}')

    return parsed





