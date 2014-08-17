

reset = ->
  Posts.remove({})
  Grafs.remove({})

Meteor.startup ->

  reset()

  for post in mockPosts
  
    postData = 
      title: post.title
      author: post.author
      link: post.link
      grafs: []
      date: post.date

    for graf in post.grafs
      grafData =
        text: graf.text
        quote: graf.quote
      grafId = Grafs.insert grafData
      postData.grafs.push(grafId)

    Posts.insert postData