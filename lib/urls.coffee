Router.map ->
  
  this.route 'stream',
    path: '/:slug'
    data: ->
      slug = @params.slug or 'mock'
      s = Streams.findOne({'slug': slug})

      if s
        s.posts = Posts.find {streamId: s._id},
            sort:
              date: -1
        return s
    waitOn: ->
      Meteor.subscribe('streams')


  this.route 'reader',
    path: '/reader/:_id'
    data: ->
      Posts.findOne @params._id
    waitOn: ->
      Meteor.subscribe('streams')

Router.configure
  layoutTemplate: 'master'