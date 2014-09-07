
if Meteor.isClient

  remarked = new reMarked()
  @markdownify = (html) ->
    md = remarked.render(html)
    md = md.replace(/<(?:.|\n)*?>/gm, '')

    return md

  showdown = new Showdown.converter()
  @htmlify = (md) ->
    html = showdown.makeHtml(md)
    return html
    
if Meteor.isServer

  toMarkdown = Meteor.npmRequire('to-markdown').toMarkdown
  @markdownify = (html) ->
    md = toMarkdown(html).trim()
    md.replace(/<(?:.|\n)*?>/gm, '')

@postToMarkdown = (post) ->

  frontMatter = """---
title: #{ post.title }
author: Jon Noronha
date: #{ post.date }
source:
  author: #{ post.author }
  domain: #{ post.domain }
  link: #{ post.link }
  date: #{ post.datePublished }
---
"""

  md = frontMatter
  for graf in post.grafs   
    if graf.quote
      md += ("\n\n\t" + graf.text)
    else
      md += "\n\n" + graf.text

  return md

