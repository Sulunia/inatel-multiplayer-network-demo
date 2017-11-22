mainMenu = {}

function mainMenu.load()
	--Graphics
	love.graphics.setBackgroundColor(255, 255, 255)
	gameLogo = love.graphics.newImage("gfx/swang3.png")
	buttonIdle = love.graphics.newImage("gfx/swang.png")
	buttonPressed = love.graphics.newImage("gfx/swang2.png")
	
	spinner = love.graphics.newImage("gfx/spinner.png")
	
	--Sound
	hoverSFX = love.audio.newSource("sfx/hoverOption.wav", "static")
	clickSFX = love.audio.newSource("sfx/blip1.wav", "static")
	
	--Variables
    spinning = 0
	spinAngle = 0
	
	network:createClient() 		--Creates client from game
	
end

function mainMenu.update(dt)
	if suit.ImageButton(buttonIdle,{active=buttonPressed}, (actualWindowsResX/2-buttonIdle:getWidth()/2), 
	actualWindowsResY*0.7).hit and network:state() ~= "connecting" then
		debugLog("Connecting to server..")
		network:connectToServer()	--Connects to specified game server
		clickSFX:stop()
		clickSFX:play()
	end
	
	--Manages loading spinner animation
	if network:state() == "connecting" then
		spinning = spinning + (432*dt)
		if spinning > 36 then
			spinAngle = spinAngle + 36
			spinning = 0
			if spinAngle == 9000 then spinAngle = 0 end
		end
	end
	
	if network:state() == "connected" then
		debugLog("Connection succeeded.")
		debugLog("Switching screen ->> Ingame")
		Screen = 1
		ingame.load()
	end
	
end

function mainMenu.draw()
	suit.draw()
	push:apply("start")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(gameLogo, internalResX/2, internalResY/4, 0, 1, 1, gameLogo:getWidth()/2, gameLogo:getHeight()/2)
	
	if network:state() == "connecting" then
		love.graphics.draw(spinner, internalResX/2, internalResY/1.8, math.rad(spinAngle), 0.7, 0.7, spinner:getWidth()/2, spinner:getHeight()/2)
	end
	
	
	
	push:apply("end")
end

function mainMenu.dispose()

end