if Meteor.isServer

  READABILITY_TOKEN = 'df4c2c43176ec936c2f401bcb8f2f6c04e1a5529'

  Readability = Meteor.require('readability-api')
  Readability.configure
    parser_token: READABILITY_TOKEN

  Meteor.methods
    fetchLink: (url) ->

      readability_url = "https://readability.com/api/content/v1/parser?url=#{ url }&token=#{ READABILITY_TOKEN}"
      log "Fetching", readability_url
      response = HTTP.get(readability_url)
      data = response.data
      postData =
          title: data.title
          author: data.author
          link: data.url
          datePublished: data.date_published
          date: new Date()
          domain: data.domain

      log postData
      Post.create postData

