-- Debug utilities for Love2d

function debugBeginTimer()
	startTime = love.timer.getTime()
	love.mouse.setVisible(true)
	print('"If I find in myself desires which nothing in this world')
	print('can satisfy, the only logical explanation is that')
	print('I was made for another world."')
	print("C.S. Lewis")
	print("----")
	debugLog("Initialized debugger internal timer.")
	return startTime
end

function debugLog(text)
	assert(text, "Can't print nil value onscreen! (Debug)")
	newTime = love.timer.getTime()
	debugTime = newTime - startTime
	print('['..round(debugTime, 4)..']' .. "\t" .. text)
end
 
function debugDrawMousePos(mx, my)
	if mx == nil then mx = 0 end
	if my == nil then my = 0 end
	push:apply("start")
	love.graphics.rectangle("fill", mx, my, 4, 4)
	love.graphics.print("X: "..round(mx, 2).." Y: "..round(my, 2), mx-70, my-23)
	push:apply("end")
end
