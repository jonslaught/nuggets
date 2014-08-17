@Posts = new Meteor.Collection "posts",
  transform: (doc) ->
    return new Post(doc)

class @Post
  constructor: (doc) ->
    _.extend(@, doc)

  @create: (data) ->
    p = Posts.insert(data)
    Posts.findOne(p)

  createGraf: (graf) ->
    graf ?= {}
    graf.text ?= ""
    graf._id = Random.id()
    graf.postId = @_id # pointer if needed
    return graf

  addGraf: (graf) ->
    graf = @createGraf(graf)
    @grafs.push(graf)
    @save()

  addGrafAfter: (afterId, graf) ->
    graf = @createGraf(graf)
    afterIndex = _.findIndex(@grafs, (g) -> g._id == afterId)
    @grafs = _.first(@grafs, afterIndex + 1).concat(graf).concat(_.rest(@grafs, afterIndex + 1))
    @save()

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