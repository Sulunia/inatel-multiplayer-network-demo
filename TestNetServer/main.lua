-- server.lua
sock = require "sock"

function love.load()
    -- Creating a server on any IP, port 22122
    --server = sock.newServer("localhost", 22122)
	server = sock.newServer("*", 22122)
	print("SERVER WINDOW")
	ticks = 0
	tickRate = 0
	blocks = {}
	tickGlobal = 10
	count = 0

    -- Called when someone connects to the server
    server:on("connect", function(data, client)
        -- Send a message back to the connected client
				print("A new client has connected.")
				r = love.math.random(255)
				g = love.math.random(255)
				b = love.math.random(255)

				clientId = client:getIndex()
				table.insert(blocks, newBlock(r, g, b, clientId))
				server:sendToPeer(server:getPeerByIndex(clientId), "playerTile", {newBlock(r, g, b, clientId), blocks})
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

		server:on("playerUpdate", function(info, client)
			peerPos = client:getIndex()
			for i, v in ipairs(blocks) do
				if blocks[i].id == client:getIndex() then
					blocks[i] = info
				end
			end
		end)

		server:on("newChatMessage", function(data, client)
			server:sendToAll("receiveChatMsg", "[Player "..client:getIndex().."]: "..data)
		end)

end

function love.update(dt)
		count = count + (dt*1000)
    if (ticks % tickGlobal == 0) then
		server:sendToAll("globalUpdate", blocks)
		tickRate = tickRate + 1
	end
	server:update()
	if count >= 1000 then
		print("Total data sent: "..(server:getTotalSentData()/1024).." // Ticks per second: "..tickRate)
		tickRate = 0
		count = 0
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
