--External libs import
require("modules/externals/autobatch")
--require("modules/externals/lovedebug")
push = require("modules/externals/push")
sock = require "sock"
suit = require ("modules/externals/suit")

--Utils import
require("modules/utils/debugUtils")
network = require("modules/utils/networkUtils")
require("modules/utils/miscUtils")

--Game Screens Require
require("mainmenu")
require("ingame")
Screen = 0

--Global variables
internalResY = 1080
internalResX = 1920
actualWindowsResX = 0
actualWindowsResY = 0

function love.load()
	debugBeginTimer()
	screenInit()
	mainMenu.load()
	
end

function love.update(dt)
	require("lovebird").update()
	if network:state() ~= nil then 
		network:update()
	end
	
	if Screen == 0 then
		mainMenu.update(dt)
	else
		ingame.update(dt)
	end
	actualWindowsResX, actualWindowsResY = love.graphics.getDimensions()
end


function love.draw()
	love.graphics.setColor(255, 255, 255)
	if Screen == 0 then 
		mainMenu.draw()
	else
		ingame.draw()
	end
	love.graphics.setColor(255, 255, 255)
	mx, my = love.mouse.getPosition()
	mx, my = push:toGame(mx, my)
	debugDrawMousePos(mx, my)
end


function love.resize(w, h)
	push:resize(w, h)
end

--//Core functions

function screenInit()
	local windowWidth, windowHeight = love.window.getDesktopDimensions()
	windowWidth, windowHeight = windowWidth*.6, windowHeight*.6
	push:setupScreen(internalResX, internalResY, windowWidth, windowHeight, {fullscreen = false, resizable=true, vsync = false})
end

function love.quit()
	client:send("disconnect", data)
end