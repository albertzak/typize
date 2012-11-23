$ ->
	typize = $('#typize')
	view = $(window)

	# Save the editablecontent in a localStorage variable
	# 
	typize.html localStorage.getItem('typize_content') if localStorage.getItem('typize_content')
	typize.html $.base64.decode(document.location.hash.substr(1)) if document.location.hash

	typize.css('min-height', $(window).height()-170)

	typize.bind 'input propertychange', keyup = =>
		captureInput()
		localStorage.setItem('typize_content', typize.html())
		document.location.hash = $.base64.encode(typize.html())

	$('#b_reset').bind 'click', click = (c) =>
		c.preventDefault()
		localStorage.clear()
		document.location.hash = '' # load default content from server
		location.reload()

	$('#b_clear').bind 'click', click = (c) =>
		c.preventDefault()
		localStorage.clear()
		document.location.hash = '#CgkJCTxkaXYgY2xhc3M9ImhyIj48YnI+PC9kaXY+CgkJ' # empty div
		location.reload()


	# Prevent browsers from inserting <br> or <div> tags when return is pressed. Doesn't work reliably though	
	typize.keydown = (k) ->
		if k.keyCode is 13
			k.preventDefault()
		if k.keyCode is 13 && k.shiftKey
			k.preventDefault()

	captureInput = ->
		typize.lines = (typize.children())
		stylizeLines sanitizeLines(typize.lines)

	stylizeLines = (lineArray)	->
		lineArray.forEach printDebug = (line, i) ->	
			if 0 < line.text().length <= 10
				line.addClass 'lt' + line.text().length
			if line.text().length > 10
				line.addClass 'gt10'
			if line.text().length is 0
				line.addClass 'hr'
		
	sanitizeLines = (lineArray) ->
		sanitizedLines = []
		lineArray.each sanitize = (i, line) =>
			line = $(line)
			line.removeClass()

			###
			Some attempts to fix Firefox's default behavior for the return key.
			They break Chrome, so I've commented them out.
			###
			#line.html line.html().replace('<br type="_moz"></br>', '')
			#line.html line.html().replace('</br>','')	# handle Firefox newlines
			#line.html line.html().replace('<br>','X')

			sanitizedLines.push line

		###
		The returned array's elements are jQuery references to the actual
		DOM elements. Apply styling etc. via jQuery functions only.
		###
		sanitizedLines


	stylizeLines sanitizeLines(typize.children())