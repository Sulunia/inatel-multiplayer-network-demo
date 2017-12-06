--networkUtils library
--Encages sock functions for more easier and cleaner implementation/call

network = {}
client = {}
gameConnected = false
gameConnecting = false
playerInfo = {}
playerReceivedInfo = false
worldGameInfo = {}
oldWorldGameInfo = {}

function network.createClient()
  client = sock.newClient("192.168.0.100", 22122)
	--client = sock.newClient("localhost", 22122)

	--      >>>>> General Library Events
	-- Called when a connection is made to the server
    client:on("connect", function(data)
        debugLog("Client connected to the server.")
		gameConnected = true
    end)

    -- Called when the client disconnects from the server
    client:on("disconnect", function(data)
    debugLog("Client disconnected from the server.")
		gameConnecting = false
		gameConnected = false
    end)

	  client:on("serverDebugInfo", function(data)
		  if data ~= nil then
			 debugLog("Server message: "..data)
		 end
	end)


	-- Game Specific Events
	client:on("receiveChatMsg", function(data)
		if data == nil then data = "" end
		table.insert(logLines, data)
	end)

	client:on("playerTile", function(data)
		playerInfo = data[1] --Player's own information
		worldGameInfo = data[2] --Other connected players informations
    oldWorldGameInfo = data[2]
		playerReceivedInfo = true
		debugLog("Received initial server informations.")
	end)

  client:on("newPlayer", function(data)
    oldWorldGameInfo = data
    worldGameInfo = data
    table.insert(logLines, "A new player has entered the fray!".."\n")
  end)

  client:on("playerLeft", function(data)
    oldWorldGameInfo = data
    worldGameInfo = data
    table.insert(logLines, "Player left!".."\n")
  end)

	client:on("globalUpdate", function(data)
    worldGameInfo = data
		client:send("playerUpdate", playerInfo)
	end)

end

function network.connectToServer()
	if client:getState() ~= "connected" then
		client:connect()
	end
end

function network.update()
	--Update current connection status\
	state = client:getState()
	client:update()
end

function network.state()
	return client:getState()
end

function network.send(msg, data)
	client:send(msg, data)
end


return network
