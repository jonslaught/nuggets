Router.map ->
  
  this.route 'posts',
    path: '/'
    data: {posts: Posts.find()}

Router.configure
  layoutTemplate: 'master'