@Streams = new Meteor.Collection "streams",
  transform: (doc) ->
    return new Stream(doc)

@Posts = new Meteor.Collection "posts",
  transform: (doc) ->
    return new Post(doc)

class @Stream extends Model

  constructor: (doc) ->
    _.extend(@, doc)
    @_collection = Streams

if Meteor.isServer
  Meteor.publish 'streams', ->
    return [
      Streams.find({}),
      Posts.find({})
    ]

class @Post extends Model

  constructor: (doc) ->
    _.extend(@, doc)
    @_collection = Posts
    @grafs ?= []

    for graf, i in @grafs
      @grafs[i] = new Graf(graf)

  createGraf: (graf) ->
    graf = new Graf(graf)
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

  getContent: ->
    if not @content?
      Meteor.call 'readability.parse', @link, (err, response) =>
        @content = response.content
        @save()


class @Graf
  constructor: (doc) ->
    _.extend(@, doc)
    @_id ?= Random.id()
    @text ?= ""

  update: (modifier) ->
    changes = modifier.$set # only set is supported for now
    Posts.findOne(@postId).updateGraf(@_id, changes)

  delete: ->
    Posts.findOne(@postId).removeGraf(@_id)