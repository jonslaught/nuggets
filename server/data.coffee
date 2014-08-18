

reset = ->
  Posts.remove({})
  #Grafs.remove({})

Meteor.startup ->

  reset()

  for post in mockPosts
  
    postData = 
      title: post.title
      author: post.author
      link: post.link
      grafs: []
      date: post.date

    p = Post.create postData

    for graf in post.grafs
      grafData =
        text: markdownify(graf.text)
        quote: graf.quote
      
      p.addGraf(grafData)