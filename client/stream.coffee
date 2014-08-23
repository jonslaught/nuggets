Template.stream.events
  'submit .stream--new': (event, template) ->

    link = template.$('.stream--new--link').val()
    Session.set('fetching', true)

    onFetched = ->
      Session.set('fetching', false)

    Meteor.call('fetchLink', link, onFetched)

    event.preventDefault()
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