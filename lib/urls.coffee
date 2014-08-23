Router.map ->
  
  this.route 'stream',
    path: '/'
    data: ->
      s = Streams.findOne()
      if s
        s.posts = Posts.find {streamId: s._id},
            sort:
              date: -1
        return s
    waitOn: ->
      Meteor.subscribe('streams')

Router.configure
  layoutTemplate: 'master'