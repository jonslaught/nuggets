Template.blog.events
  'submit .blog--new': (event, template) ->

    link = template.$('.blog--new--link').val()
    Session.set('fetching', true)

    onFetched = ->
      Session.set('fetching', false)

    Meteor.call('fetchLink', link, onFetched)

    event.preventDefault()
    return false

  'click .blog--download': ->
    data = Posts.find().fetch()
    encoded = "text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(data, null, 2))
    $('<a href="data:' + encoded + '" download="posts.json">download JSON</a>')[0].click();

  'mouseup .blog--upload': ->
    $('.blog--upload--input').click()

  'change .blog--upload--input': (event) ->
    reader = new FileReader()
    file = event.target.files[0]
    reader.onload = (e) ->
      contents = e.target.result
      data = JSON.parse(contents)
      for post in data
        Posts.insert post
    reader.readAsText(file)