Router.map ->
  
  this.route 'blog',
    path: '/'
    data: {posts: Posts.find()}

Router.configure
  layoutTemplate: 'master'