myLayers = Framer.Importer.load "imported/prototype"
Framer.Shortcuts.initialize myLayers

APP = {}
APP.movieArray = [Show01, Show02, Show03, Show04]
APP.curve = 'bezier-curve'
APP.curveOptions = [.6, 0, .4, 1]


# left menu setup
LeftMenu.backgroundColor = '#000'
LeftMenu.fluid
	autoHeight: true
LeftMenu.fix()
Logo.fluid
	yAlign: 'bottom'
	yOffset: -20
Logo.fix()

# movie card setup
_.each APP.movieArray, (movie) ->
	movie.style =
		cursor: 'pointer'
	movie.subLayers[0].opacity = .5


Show01.fluid
	autoWidth: true
Image01.fluid
	autoWidth: true
Social01.fluid
	xAlign: 'right'
	xOffset: -80
Show02.fluid
	autoWidth: true
Image02.fluid
	autoWidth: true
ContentBox02.fluid
	xAlign: 'right'
Show03.fluid
	autoWidth: true
Image03.fluid
	autoWidth: true
Social03.fluid
	xAlign: 'right'
	xOffset: -80
Show04.fluid
	autoWidth: true
Image04.fluid
	autoWidth: true
ContentBox04.fluid
	xAlign: 'right'

movieSelected = (evt) ->
	movieOut @
	id = Number @name.substr -1
	_.each APP.movieArray, (layer) ->
		lid = Number layer.name.substr -1
		shiftMovieDown layer if lid > id
	Utils.delay .25, ()=> 
		@.bringToFront()
		LeftMenu.bringToFront()
		Logo.bringToFront()
	@.subLayers[0].animate
		properties:
			height: @.originalFrame.height + 100
			opacity: 1
		curve: APP.curve
		curveOptions: APP.curveOptions
		time: .5
	@.subLayers[2].animate
		properties:
			y: @.subLayers[2].originalFrame.y + 100
		curve: APP.curve
		curveOptions: APP.curveOptions
		time: .5
	@.subLayers[1].subLayers[0].animate
		properties:
			height: @.originalFrame.height + 100
		curve: APP.curve
		curveOptions: APP.curveOptions
		time: .5
	@.subLayers[1].subLayers[1].animate
		properties:
			y: @.subLayers[1].subLayers[1].originalFrame.y + 100
		curve: APP.curve
		curveOptions: APP.curveOptions
		time: .5
	@.animate
		properties:
			height: @.originalFrame.height + 100
		curve: APP.curve
		curveOptions: APP.curveOptions
		time: .5

shiftMovieDown = (layer) ->
	layer.animateStop()
	layer.animate
		properties:
			y: layer.originalFrame.y + 100
		curve: APP.curve
		curveOptions: APP.curveOptions
		time: .5

shiftMovieBack = (layer) ->
	layer.animateStop()
	layer.animate
		properties:
			y: layer.originalFrame.y
		curve: APP.curve
		curveOptions: APP.curveOptions
		time: .5

movieOut = (emitter) ->
	_.each APP.movieArray, (layer) ->
		shiftMovieBack layer
		if layer != emitter
			layer.subLayers[0].animate
				properties:
					height: layer.originalFrame.height
					opacity: .5
				curve: APP.curve
				curveOptions: APP.curveOptions
				time: .5
			layer.subLayers[2].animate
				properties:
					y: layer.subLayers[2].originalFrame.y
				curve: APP.curve
				curveOptions: APP.curveOptions
				time: .5
			layer.subLayers[1].subLayers[0].animate
				properties:
					height: layer.originalFrame.height
				curve: APP.curve
				curveOptions: APP.curveOptions
				time: .5
			layer.subLayers[1].subLayers[1].animate
				properties:
					y: layer.subLayers[1].subLayers[1].originalFrame.y
				curve: APP.curve
				curveOptions: APP.curveOptions
				time: .5
			layer.animate
				properties:
					height: layer.originalFrame.height
				curve: APP.curve
				curveOptions: APP.curveOptions
				time: .5

Show01.on Events.Click, movieSelected
Show02.on Events.Click, movieSelected
Show03.on Events.Click, movieSelected
Show04.on Events.Click, movieSelected
	


