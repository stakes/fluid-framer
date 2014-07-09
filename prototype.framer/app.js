myLayers = Framer.Importer.load("imported/prototype")

// Demo code
// Bounce all the views

for (layerName in myLayers) {

	var layer = myLayers[layerName];

	layer.on(Events.Click, function(event, layer) {
		
		// Wind up the layer by making it smaller
		layer.scale = 0.7

		// Animate the layer back to the original size with a spring
		layer.animate({
			properties: {scale:1.0},
			curve: "spring",
			curveOptions: {
				friction: 15,
				tension: 1000,
			}
		})

		// Only animate this layer, not other ones below
		event.stopPropagation()
	})
}