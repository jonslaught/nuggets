
Template.graf.rendered = ->
  if not @data.text
    @find('.graf').focus()

  Deps.autorun =>
    @$('.graf').html(@data.text) # hacky workaround for blaze bug

Template.post.events
  'click .post--adder': ->
    @addGraf()

Template.graf.events
  'blur .graf': (event, template) ->
    post = Posts.findOne(@postId)
    grafNode = template.$('.graf')
    if grafNode.text().trim()
      post.updateGraf(@_id, {text: grafNode.html()})
    else
      post.removeGraf(@_id)


  'keydown .graf': (event, template) ->
    key = event.which
    shift = event.shiftKey
    ctrl = event.metaKey

    # Enter
    if key == 13 and not shift

      post = Posts.findOne(@postId)
      post.addGrafAfter(@_id, {quote: @quote})

      event.preventDefault()
      return false

