
if Meteor.isClient

  remarked = new reMarked()
  @markdownify = (html) ->
    md = remarked.render(html)
    md = md.replace(/<(?:.|\n)*?>/gm, '')
    return md

  showdown = new Showdown.converter()
  @htmlify = (md) ->
    html = showdown.makeHtml(md)
    

if Meteor.isServer

  html_md = Meteor.require('html-md')
  @markdownify = (html) ->
    md = html_md(html, {inline: true})
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


