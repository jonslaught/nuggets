Template.post.grafs = ->
  (Grafs.findOne(g) for g in @grafs)