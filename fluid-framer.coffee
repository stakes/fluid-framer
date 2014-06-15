# Framer.js Layer extensions
# --------------------------
#
# If you use the Framer.js prototyping framework and you want to build "responsive" prototypes, this set of extensions to the Framer.js Layer object can be of assistance.
# 
# ####Layer.fluid()
# Initialize fluid layout for a layer. You can make any layer's width and height dynamic or set its position absolutely relative to the containing element.
#
# Layers are resized and repositioned as soon as they are initialized and whenever the browser window is resized.
#
# You might want to make an image stretch and fill the entire browser:
# ```
# myLayer.fluid
#   autoWidth: true
#   autoHeight: true
# ```
#
# Or maybe you want to pin a layer to the lower left of its parent with 10px of padding:
# ```
# myLayer.fluid
#   xAlign: 'left'
#   xOffset: 10
#   yAlign: 'bottom'
#   yOffset: -10
# ```
#
# Here are all the available options:
#
# ```
# # Expand width or height to fill containing element
# autoWidth: Boolean
# autoHeight: Boolean 
# # Add or subtract from the calculated width/height
# heightOffset: Number
# widthOffset: Number
# # Alignment within containing element
# xAlign: 'left' | 'right' | 'center' or 'middle'
# yAlign: 'bottom' | 'top' | 'center' or 'middle'
# # Position relative to alignment
# xOffset: Number
# yOffset: Number
# ```
Layer::fluid = (options = {}) ->
  Framer.Fluid.register @, options

# ####Layer.static()
# Remove a layer's fluid positioning. Whatever options you specified when you made the layer fluid initially will no longer apply. This won't reset it to its initial position, however.
#
# ```
# myLayer.static()
# ```
Layer::static = ->
  Framer.Fluid.unregister @

# ####Layer.fix()
# An easy way to set a layer to `position: fixed`. If you want to pin a static header or sidebar in your app's prototype, this can be your friend.
#
# ```
# myLayer.fix()
# ```
Layer::fix = ->
  Framer.Fluid.fix @

# ####Layer.unfix()
# An easy way to reset said layer to Framer's default positioning.
# ```
# myLayer.unfix()
# ```
Layer::unfix = ->
  Framer.Fluid.unfix @


# FluidFramer implementation
# --------------------------
# 
# If you include fluid-framer.js in your prototype's index.html file, it'll automatically create an instance of this class and add all of the shorthand methods above to the Framer.js Layer object's prototype chain. So unless you're curious, the rest is basically  implementation details.
class FluidFramer

  # Array that contains all of the fluid Layers.
  registry = []

  # Listen for `window.onresize` and respond by adjusting position and dimensions of fluid Layers.
  constructor: ->
    self = @
    window.onresize = (evt) =>
      @_respond()

  # Public method to make a Layer fluid. Called directly like `Framer.Fluid.register(myLayer)` but why bother when you can just be all `myLayer.fluid()`? 
  register: (layer, options = {}) ->
    @_addLayer layer, options

  # Samesies to stop resizing/repositioning.
  unregister: (layer) ->
    @_removeLayer layer
  
  # And these are how we change a Layer from absolute to fixed positioning and back again.
  fix: (layer) ->
    layer.style =
      position: 'fixed'
    layer
  unfix: (layer) ->
    layer.style =
      position: 'absolute'
    layer

  # ####Framer.Fluid.layers()
  # Returns all of the Layers that are registered. Could help with debugging? Maybe?
  # ```
  # Framer.Fluid.layers() # Returns an array of Layers
  # ```
  layers: ->
    registry

  # Iterate over all of the Layers registered with FluidFramer and refresh the size and position of each. 
  _respond: ->
    self = @
    _.each registry, (obj, index) ->
      self._refreshLayer obj

  # This is where it all goes down. This will get called for each fluid Layer whenever the browser window is resized, as well as when the Layer is initially added.
  _refreshLayer: (obj) ->  
    layer = obj.targetLayer
    # Adjust width and height, based on the autoWidth and autoHeight options.
    if obj.autoWidth?
      newWidth = if obj.widthOffset? then @_parentWidth(layer) + 
        obj.widthOffset else @_parentWidth(layer)
      layer.width = newWidth
      layer.style = 
        backgroundPosition: 'center'
    if obj.autoHeight?
      newHeight = if obj.heightOffset? then @_parentHeight(layer) + 
        obj.heightOffset else @_parentHeight(layer)
      layer.height = newHeight
      layer.style = 
        backgroundPosition: 'center'
    # Set alignment within parent, based on the xAlign and yAlign options.
    switch obj.xAlign 
      when 'left'
        layer.x = @_xWithOffset obj, 0
      when 'right'
        newX = @_parentWidth(layer) - layer.width
        layer.x = @_xWithOffset obj, newX 
      when 'center' 
        layer.centerX()
        layer.x = @_xWithOffset obj, layer.x
      when 'middle'
        layer.centerX()
        layer.x = @_xWithOffset obj, layer.x
    switch obj.yAlign
      when 'bottom'
        newY = @_parentHeight(layer) - layer.height
        layer.y = @_yWithOffset obj, newY
      when 'top'
        layer.y = @_yWithOffset obj, 0
      when 'middle'
        layer.centerY()
        layer.y = @_yWithOffset obj, layer.y
      when 'center'
        layer.centerY()
        layer.y = @_yWithOffset obj, layer.y

  # If there are xOffset or yOffset values, apply them before repositioning the Layer.
  _xWithOffset: (obj, x) ->
    x = if obj.xOffset? then x + obj.xOffset else x
  _yWithOffset: (obj, y) ->
    y = if obj.yOffset? then y + obj.yOffset else y

  # Check to see whether the Layer has a superLayer or is on the top level, and return either the superLayer's dimensions or the browser window's.
  _parentWidth: (layer)->
    if layer.superLayer? then layer.superLayer.width else window.innerWidth
  _parentHeight: (layer)->
    if layer.superLayer? then layer.superLayer.height else window.innerHeight

  # Add a layer to the registry.
  _addLayer: (layer, options = {}) ->
    obj = _.extend options, targetLayer: layer
    registry.push obj
    # Layers can be added before the DOM is fully loaded. So, use Framer's `domComplete` method to wait until we're good to go before positioning the layer.
    self = @
    Utils.domComplete ()->
      self._refreshLayer obj, self
    layer

  # Remove a layer from the registry.
  _removeLayer: (layer) ->
    target = _.findWhere registry, {targetLayer: layer}
    # But ditch if the target layer isn't registered.
    return layer if !target?
    if target.autoWidth? or target.autoHeight?
      target.style =
        backgroundPosition: 'initial'
    registry = _.without registry, target
    target

# Initialize the FluidFramer object as `Framer.Fluid`.
Framer.Fluid = new FluidFramer