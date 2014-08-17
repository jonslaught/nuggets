Template.post.grafs = ->
  (Grafs.findOne(g) for g in @grafs)


Template.graf.rendered = ->
  if not @data.text
    @find('.graf').focus()

Template.post.events
  'click .post--adder': (event, template) ->
    
    
    g = Grafs.insert({})
    Posts.update @_id,
      $push:
        grafs:
          g
    