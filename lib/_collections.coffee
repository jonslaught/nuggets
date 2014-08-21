
Meteor.Collection::create = (data) ->
  data ?= {}
  i = @insert data
  return @findOne i    

class @Model

  update: (modifier) ->
    @_collection.update @_id, modifier

  save: ->
    c = @_collection
    delete @_collection
    c.update @_id, @
    @_collection = c

  delete: ->
    @_collection.delete @_id
