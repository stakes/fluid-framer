# Fluid Layers for Framer.js

If you use the Framer.js prototyping framework and you want to build "responsive" prototypes, this set of extensions to the Framer.js Layer object can be of assistance. It adds the flexibiity to dynamically scale and float elements in the browser window or within their superLayer.

### Usage

Include [fluid-framer.js](https://rawgit.com/stakes/fluid-framer/master/build/fluid-framer.js) in your `index.html` file:
```
<body>
  <script src="fluid-framer.js"></script>
  <script src="app.js"></script>
</body>
```

And now give any layer dynamic dimensions and/or position like so:
```
myLayer.fluid
  autoWidth: true
myOtherLayer.fluid
  xAlign: 'right'
  xOffset: -25
```


### Documentation

####Layer.fluid()
Initialize fluid layout for a layer. You can make any layer's width and height dynamic or set its position absolutely elative to the containing element.

Layers are resized and repositioned as soon as they are initialized and whenever the browser window is resized.

You might want to make an image stretch and fill the entire browser:
```
myLayer.fluid
 autoWidth: true
 autoHeight: true
```

Or maybe you want to pin a layer to the lower left of its parent with 10px of padding:
```
myLayer.fluid
 xAlign: 'left'
 xOffset: 10
 yAlign: 'bottom'
 yOffset: -10
```

Here are all the available options:

```
# Expand width or height to fill containing element
autoWidth: Boolean
autoHeight: Boolean 
# Add or subtract from the calculated width/height
heightOffset: Number
widthOffset: Number
# Alignment within containing element
xAlign: 'left' | 'right' | 'center' or 'middle'
yAlign: 'bottom' | 'top' | 'center' or 'middle'
# Position relative to alignment
xOffset: Number
yOffset: Number
```

####Layer.static()
Remove a layer's fluid positioning. Whatever options you specified when you made the layer fluid initially will no longer apply. This won't reset it to its initial position, however.

```
myLayer.static()
```

####Layer.fix()
An easy way to set a layer to `position: fixed`. If you want to pin a static header or sidebar in your app's prototype, this can be your friend.

```
myLayer.fix()
```

####Layer.unfix()
An easy way to reset said layer to Framer's default positioning.
```
myLayer.unfix()
```

####Framer.Fluid.layers()
Returns all of the Layers that are registered. Could help with debugging? Maybe?
```
Framer.Fluid.layers() # Returns an array of Layers
```

And the [annotated source](http://github.io/stakes/fluid-framer) has more.