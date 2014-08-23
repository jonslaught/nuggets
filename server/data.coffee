

reset = ->
  Posts.remove({})
  Streams.remove({})
  #Grafs.remove({})

Meteor.startup ->

  reset()

  stream = Streams.create
    title: "Jon's Blog"
    description: "A bunch of nuggets"

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