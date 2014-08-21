
Template.graf.rendered = ->
  if not @data.text
    @find('.graf--body .editable').focus()


Template.blog.events
  'submit .blog--new': (event, template) ->

    link = template.$('.blog--new--link').val()
    Session.set('fetching', true)

    onFetched = ->
      Session.set('fetching', false)

    Meteor.call('fetchLink', link, onFetched)

    event.preventDefault()
    return false

Template.post.events
  'click .post--adder': ->
    @addGraf()

Template.graf.events

  'keydown .graf--body': (event, template) ->
    grafNode = template.$('.graf--body')
    key = event.which
    shift = event.shiftKey
    ctrl = event.metaKey

    # Enter
    if key == 13 and not shift

      post = Posts.findOne(@postId)
      post.addGrafAfter(@_id, {quote: @quote})

      event.preventDefault()
      return false

    # Indent
    if key == 9
      post = Posts.findOne(@postId)
      change = if shift then {quote: false} else {quote: true}
      post.updateGraf(@_id, change)
      event.preventDefault()
      return false

    # Backspace
    if key == 8
      post = Posts.findOne(@postId)
      empty = not grafNode.text().trim()
      if empty and @quote
        post.updateGraf(@_id, {quote: false})
      else if empty
        post.removeGraf(@_id)