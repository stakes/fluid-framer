###
  Fluid Framer extensions

###

class FluidFramer

  registry = []

  ###
    ACTIVATE RESPONSIVE
  ###
  constructor: ->
    self = @
    window.onresize = (evt) =>
      @_respond()

  ###
    REGISTER LAYER
  ###
  register: (layer, options = {}) ->
    @_addLayer layer, options

  ###
    FIX LAYER (shorthand for style = position: 'fixed')
  ###
  fix: (layer) ->
    layer.style =
      position: 'fixed'
  unfix: (layer) ->
    layer.style =
      position: 'absolute'

  ###
    GET REGISTERED LAYERS
  ###
  layers: ->
    registry

  ###
    RESPOND TO CHANGES
  ###
  _respond: ->
    self = @
    _.each registry, (obj, index) ->
      self._refreshLayer obj

  _refreshLayer: (obj) ->  
    layer = obj.targetLayer
    # adjust width
    if obj.autoWidth?
      newWidth = if layer.superLayer? then layer.superLayer.width else window.innerWidth
      if obj.widthOffset? then newWidth = newWidth + obj.widthOffset
      layer.width = newWidth
    # adjust height
    if obj.autoHeight?
      newHeight = if layer.superLayer? then layer.superLayer.height else window.innerHeight
      if obj.heightOffset? then newHeight = newHeight + obj.heightOffset
      layer.height = newHeight
    # alignment within parent
    switch obj.yAlign
      when 'bottom'
        newY = if layer.superLayer? then layer.superLayer.height else window.innerHeight
        newY = newY - layer.height
        layer.y = @_yWithOffset obj, newY
      when 'top'
        layer.y = @_yWithOffset obj, 0
      when 'middle'
        layer.centerY()
        layer.y = @_yWithOffset obj, layer.y
      when 'center'
        layer.centerY()
        layer.y = @_yWithOffset obj, layer.y
    switch obj.xAlign 
      when 'left'
        layer.x = @_xWithOffset obj, 0
      when 'right'
        newX = if layer.superLayer? then layer.superLayer.width else window.innerWidth
        newX = newX - layer.width
        layer.x = @_xWithOffset obj, newX 
      when 'center' 
        layer.centerX()
        layer.x = @_xWithOffset obj, layer.x
      when 'middle'
        layer.centerX()
        layer.x = @_xWithOffset obj, layer.x

  _xWithOffset: (obj, x) ->
    x = if obj.xOffset? then x + obj.xOffset else x

  _yWithOffset: (obj, y) ->
    y = if obj.yOffset? then y + obj.yOffset else y



  ###
    ADD/REMOVE LAYERS FROM REGISTRY
  ###
  _addLayer: (layer, options = {}) ->
    layer.style = 
      backgroundPosition: 'center'
    obj = 
      targetLayer: layer
      autoWidth: options.autoWidth
      autoHeight: options.autoHeight
      widthOffset: options.widthOffset
      heightOffset: options.heightOffset
      xAlign: options.xAlign
      yAlign: options.yAlign
      xOffset: options.xOffset
      yOffset: options.yOffset
    registry.push obj
    self = @
    Utils.domComplete ()->
      self._refreshLayer obj, self

  _removeLayer: (layer) ->
    target = _.findWhere @registry, {layer: layer}
    registry = _.without registry, target



Framer.Fluid = new FluidFramer

Layer::fluid = (options = {}) ->
  Framer.Fluid.register @, options

Layer::static = ->
  Framer.Fluid.unregister @

Layer::fix = ->
  Framer.Fluid.fix @

Layer::unfix = ->
  Framer.Fluid.unfix @