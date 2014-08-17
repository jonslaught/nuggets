Router.map ->
  
  this.route 'blog',
    path: '/'
    data:
      posts: Posts.find {},
        sort:
          date: -1

Router.configure
  layoutTemplate: 'master'