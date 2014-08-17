@Posts = new Meteor.Collection "posts",
  transform: (doc) ->
    return new Post(doc)

class @Post
  constructor: (doc) ->
    _.extend(@, doc)

  @create: (data) ->
    p = Posts.insert(data)
    Posts.findOne(p)

  addGraf: (graf) ->
    
    graf ?= {}
    graf.text ?= ""
    graf._id = Random.id()
    graf.postId = @_id # pointer if needed
    @grafs.push(graf)
    @save()

  addGrafAfter: (afterId, graf) ->
    @addGraf(graf)

  updateGraf: (id, changes) ->
    @grafs = _.map @grafs, (graf) ->
      if graf._id == id
        _.extend(graf, changes)
      else
        graf
    @save()

  removeGraf: (id) ->
    _.remove @grafs, (graf) -> graf._id == id
    @save()

  save: ->
    Posts.update @_id, @