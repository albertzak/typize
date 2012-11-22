$ ->
	typize = $('#typize')
	view = $(window)
	info = $('#info')

	# localStorage
	typize.html localStorage.getItem('typize_content') if localStorage.getItem('typize_content')
	typize.bind 'input propertychange', keyup = =>
		captureInput()
		localStorage.setItem('typize_content', typize.html())
	typize.keyup = (k) ->
		if k.keyCode is 13
			k.preventDefault()

	captureInput = ->

		typize.lines = (typize.children())
		info.html ''
		stylizeLines sanitizeLines(typize.lines)

	stylizeLines = (lineDescriptor)	->
		lines = lineDescriptor[0]
		lineLengths = lineDescriptor[1]

		lines.forEach printDebug = (line, i) ->
			info.html info.html() + line.text() + ', trueLength: ' + lineLengths[i] + '<br>'
			switch lineLengths[i]
				when 0 then line.addClass 'lt1'
				when 1 then line.addClass 'lt2'
				when 2 then line.addClass 'lt3'
				when 3 then line.addClass 'lt4'
				when 4 then line.addClass 'lt5'
				else line.addClass 'gt4'

		
	sanitizeLines = (lineArray) ->
		###
		Every line inside a contenteditable field is wrapped
		in a div EXCEPT for the first line. We can't just select the
		plain text, so we push the parent element to our stack.
		Since it's the first element, we don't care about styling
		because the children's styles will have a higher priority.
		###
		sanitizedLines = []
		lineLengths = []

		sanitizedLines.push lineArray.parent()
		lineLengths.push  lineArray.parent().clone().children().remove().end().contents().text().length

		lineArray.each sanitize = (i, line) =>
			line = $(line)
			line.removeClass()
			sanitizedLines.push line
			lineLengths.push line.text().length

		###
		The returned array's elements are jQuery references to the actual
		DOM elements. Apply styling etc. via jQuery functions only.
		The number of chars per line is saved in a separate array.
		###

		lineArray.parent().sanitizedLines = sanitizedLines
		lineArray.parent().lineLengths = lineLengths

		[ sanitizedLines, lineLengths ]


			# info.text(info.text() + '[' + i+1 + '] ' + $(line).text() + ' (' + $(line).text().length + ')')
			# switch $(line).text().length
			# when 0 then alert 'zero' # insert hr
			# when 1, 2 then $(line).addClass 'lt4' # circle, script font
			# when 3, 4 then $(line).addClass 'lt2'


	stylizeLines sanitizeLines(typize.children())