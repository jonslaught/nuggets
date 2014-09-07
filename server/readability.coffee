

class ReadabilityConnection

  constructor: (token) ->
    @token = token

  parse: (url) ->

    readability_url = "https://readability.com/api/content/v1/parser?url=#{ url }&token=#{ @token }"
    response = HTTP.get(readability_url)
    data = response.data
    postData =
        title: data.title
        author: data.author
        link: data.url
        datePublished: data.date_published
        date: new Date()
        readability: data
        content: markdownify(data.content)

    return postData


 # config lives here
@Readability = new ReadabilityConnection(TOKENS.readability.parserToken)

Meteor.methods
  'readability.parse': (url) ->
    return Readability.parse(url)

