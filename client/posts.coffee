Template.post.grafs = ->
  (Grafs.findOne(g) for g in @grafs)


Template.graf.rendered = ->
  if not @data.text
    @find('.graf').focus()

Template.post.events
  'click .post--adder': ->
    
    g = Grafs.insert({})
    Posts.update @_id,
      $push:
        grafs:
          g
    
Template.graf.events
  'blur .graf': (event, template) ->

    log 'saving', @_id, @text
    Grafs.update @_id,
      $set:
        text: template.$('.graf').html()