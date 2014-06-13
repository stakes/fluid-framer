###
  Responsive Framer

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
    @_addLayer(layer, options)

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
      self._refreshLayer(obj, self)

  _refreshLayer: (obj, self) ->  
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
    switch obj.horizontalAlign
      when 'bottom'
        newY = if layer.superLayer? then layer.superLayer.height else window.innerHeight
        newY = newY - layer.height
        newY = newY + obj.pinOffset if obj.pinOffset?
        layer.y = newY
      when 'top'
        newY = 0
        if obj.pinOffset? then newY = newY + obj.pinOffset
        layer.y = newY
      when 'middle'
        layer.centerY()
    switch obj.verticalAlign 
      when 'left'
        newX = 0
        if obj.pinOffset? then newY = newY + obj.pinOffset
        layer.x = newX
      when 'right'
        newX = if layer.superLayer? then layer.superLayer.width else window.innerWidth
        newX = newX - layer.width
        if obj.pinOffset? then newX = newX + obj.pinOffset
        layer.x = newX
      when 'center'
        layer.centerX()

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
      verticalAlign: options.verticalAlign
      horizontalAlign: options.horizontalAlign
      pinOffset: options.pinOffset
    registry.push obj
    self = @
    Utils.domComplete ()->
      self._refreshLayer(obj, self)

  _removeLayer: (layer) ->
    target = _.findWhere @registry, {layer: layer}
    registry = _.without registry, target





Framer.Fluid = new FluidFramer

Layer::fluid = (options = {}) ->
  Framer.Fluid.register(@, options)