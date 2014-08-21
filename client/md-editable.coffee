

# md-editable="title"


markdownEditable = (template, context, Collection) ->

  template.$('[md-editable]').attr('contentEditable', true)

  template.$('[md-editable]').each ->
    node = $(@)
    field = node.attr('md-editable')
    value = context[field]
    html = htmlify(value)
    node.html(html)

    node.on 'blur',
      text = node.text().trim()
      if text
        html = node.html()
        md = markdownify(html)
        # update
        changes = {}
        changes[field] = md
        Collection.update context._id,
          $set: changes

        html = htmlify(md)
        node.html(html)

      else
        # remove
        Collection.remove(context._id)