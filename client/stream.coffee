Template.stream.fetching = ->
  Session.get('fetching')

Template.stream.events
  'submit .stream--new': (event, template) ->
    event.preventDefault()

    link = template.$('.stream--new--link').val()
    $('.stream--new--button').blur()
    Session.set('fetching', true)

    Meteor.call 'readability.parse', link, (err, postData) =>
      Session.set('fetching', false)
      postData.streamId = @_id
      Posts.insert postData



    
    return false

  'click .stream--download': ->
    data = Posts.find().fetch()
    encoded = "text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(data, null, 2))
    $('<a href="data:' + encoded + '" download="posts.json">download JSON</a>')[0].click();

  'mouseup .stream--upload': ->
    $('.stream--upload--input').click()

  'change .stream--upload--input': (event) ->
    reader = new FileReader()
    file = event.target.files[0]
    reader.onload = (e) ->
      contents = e.target.result
      data = JSON.parse(contents)
      for post in data
        Posts.insert post
    reader.readAsText(file)