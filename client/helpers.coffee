

Template.editable.rendered = ->

  model = @data.model
  field = @data.field
  value = model[field]

  html = htmlify(value)
  @$('.editable').html(html)


Template.editable.events =
  'blur': (event, template) ->
    node = template.$('.editable')
    
    if node.text().trim()
      html = node.html()
      md = markdownify(html)
      changes = {}
      changes[@field] = md
      modifier = {$set: changes}
      @model.update(modifier)
      html = htmlify(md)
      node.html(html)