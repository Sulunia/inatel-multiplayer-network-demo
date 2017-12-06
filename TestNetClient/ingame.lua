ingame = {}
var1 = 0
var2 = 0

local input = {text = ""}
logLines = {}
local chatText = ""

function ingame.load()
	debugLog("Ingame loading")

	playerImage = love.graphics.newImage("gfx/swang5.png")
	--Variables
	transitionVar = 255
	transitioned = false
end

function ingame.update(dt)
if transitioned then
	--Game Loop
	--Ingame Chat (this should be moved to outside of ingame resolution handling)

	chatInput = suit.Input(input, 20, actualWindowsResY-60, actualWindowsResX*0.23, 40)
	chatBox = suit.Label(chatText, {id = "chatBox", align = "left"}, 20, actualWindowsResY-180, 500, 60)
	chatText = ""
	if chatInput.submitted == true then
		if input.text ~= "" then
			input.text = input.text.."\n"
			client:send("newChatMessage", input.text)
			input.text = ""
		end
	end

	while #logLines >= 7 do
		table.remove(logLines, 1)
	end

	--Concatenate all strings in a single block
	for i, v in ipairs(logLines) do
		chatText = chatText..v
	end

	if love.keyboard.isDown("up") then
		playerInfo.y = playerInfo.y - 20
	end
	if love.keyboard.isDown("down") then
		playerInfo.y = playerInfo.y + 20
	end
	if love.keyboard.isDown("left") then
		playerInfo.x = playerInfo.x - 20
	end
	if love.keyboard.isDown("right") then
		playerInfo.x = playerInfo.x + 20
	end

	if playerReceivedInfo then
		for i, v in ipairs(oldWorldGameInfo) do
			if(worldGameInfo[i] ~= nil) then
				v.x = lerp(v.x, worldGameInfo[i].x, 0.302)
				v.y = lerp(v.y, worldGameInfo[i].y, 0.302)
				--if(v.x >= worldGameInfo[i].x) then v.x = v.x-(dt*1000) else v.x = v.x + (dt*1000) end
				--if(v.y >= worldGameInfo[i].y) then v.y = v.y-(dt*1000) else v.y = v.y +(dt*1000) end
			end
		end
	end

else transitionScreen(dt) end
end

function ingame.draw()

	push:apply("start")
	if playerReceivedInfo then
		for i, v in ipairs(oldWorldGameInfo) do
			love.graphics.setColor(v.r, v.g, v.b, 255)
			love.graphics.draw(playerImage, v.x, v.y)
		end

		--love.graphics.setColor(playerInfo.r, playerInfo.g, playerInfo.b, 50)
		--love.graphics.draw(playerImage, playerInfo.x, playerInfo.y)
	end
	push:apply("end")
	suit.draw()
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("Ping: "..client:getRoundTripTime().."ms", actualWindowsResX*0.93, 20)
end

function ingame.dispose()

end

--====Extra Functions

function transitionScreen(dt)
	transitionVar = transitionVar - (dt*700)
	if transitionVar >= 1 then
		love.graphics.setBackgroundColor(transitionVar, transitionVar, transitionVar)
	else
		transitioned = true
	end
end

function love.textinput(t)
	suit.textinput(t)
end

function love.keypressed(key)
	suit.keypressed(key)
	--VERY IMPORTANT TODO: MODIFY SUIT SO CHAT INPUT BEHAVIOR CHANGES
end
