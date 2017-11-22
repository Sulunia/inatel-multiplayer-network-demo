-- server.lua
sock = require "sock"

function love.load()
    -- Creating a server on any IP, port 22122
    --server = sock.newServer("localhost", 22122)
	server = sock.newServer("localhost", 22122)
	print("SERVER WINDOW")
	ticks = 0
	blocks = {}
	tickGlobal = 130
	
    -- Called when someone connects to the server
    server:on("connect", function(data, client)
        -- Send a message back to the connected client
		r = love.math.random(0,255)
		g = love.math.random(0,255)
		b = love.math.random(0,255)
		clientId = client:getIndex()
		table.insert(blocks, newBlock(r, g, b, clientId))
		server:sendToAll("newPlayer", blocks)
		client:send("playerIndex", {blocks, clientId})
		print("Connection succeeded! Player ID is "..client:getIndex())
    end)
	
	server:on("disconnect", function(data, client)
		discClient = client:getIndex()
		found = false
		for i, v in ipairs(blocks) do
		
			if v.id == discClient then
				table.remove(blocks, i)
				print("removed client from table")
				found = true
			end
			if found then
				break
			end
		end
		server:sendToAll("newPlayer", blocks)
		print("Client id "..client:getIndex().." has disconnected")
	end)
	
	server:on("move", function(info, client)
		peerPos = client:getIndex()
		for i, v in ipairs(blocks) do
			if blocks[i].id == client:getIndex() then
				peerPos = i
			end
		end
		
		if info.typeM == 1 then
			blocks[peerPos].y = info.mov
		elseif info.typeM == 2 then
			blocks[peerPos].y = info.mov
		elseif info.typeM == 3 then
			blocks[peerPos].x = info.mov
		elseif info.typeM == 4 then
			blocks[peerPos].x = info.mov
		else
			print("Unknown movement type!")
		end
	end)
end

function love.update(dt)
    if (ticks % tickGlobal == 0) then
		server:sendToAll("globalUpdate", blocks)
		--print("Client sync! Tick "..ticks)
	end
	server:update()
	if ticks % 3600 == 0 then
		print("Total data sent: "..server:getTotalSentData()/1024)
	end	
	ticks = ticks + 1
end

function newBlock(rP, gP, bP, clientId)
	return {
	id = clientId,
	x = 100, 
	y = 100,
	r = rP,
	g = gP,
	b = bP
	}
end
