
Template.reader.html = ->
  if @content
    return htmlify(@content)
  else if @getContent?
    @getContent()

Template.reader.events
  'mouseup .reader--body': ->
    selection = rangy.getSelection()
    html = selection.toHtml()
    @addGraf
      text: markdownify(html)
      quote: true

    highlighter = rangy.createClassApplier 'highlighted'
    highlighter.applyToSelection()
    selection.removeAllRanges()