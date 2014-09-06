

reset = ->
  Posts.remove({})
  Streams.remove({})
  #Grafs.remove({})

Meteor.startup ->

  reset()
  loadMockData()

  
  loadInstapaperData()

loadInstapaperData = ->

  I = setupInstapaper()
  stream = Streams.create
    slug: "instapaper"
    title: "Jon's Instapaper"
    description: "Freshly exported"

  # Get all starred posts
  response = I.call('bookmarks/list', {'folder_id': 'starred'})
  highlights = response.highlights
  bookmarks = response.bookmarks

  for b in bookmarks
    postData =
      title: b.title
      link: b.url
      date: new Date(b.time * 1000) # convert to milliseconds
      grafs: []
      streamId: stream._id

    p = Posts.create postData


loadMockData = ->
  stream = Streams.create
    title: "Jon's Blog"
    description: "A bunch of nuggets"
    slug: "mock"

  for post in mockPosts
  
    postData = 
      title: post.title
      author: post.author
      link: post.link
      grafs: []
      date: post.date
      streamId: stream._id

    p = Posts.create postData

    for graf in post.grafs
      grafData =
        text: markdownify(graf.text)
        quote: graf.quote
      
      p.addGraf(grafData)