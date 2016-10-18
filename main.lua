local Gamestate = require 'gamestate'
local window = require 'window'
require 'trace'

function love.load()
	--pass
	local state = 'update'

	Gamestate.switch(state)
end

function love.update(dt)
	--pass
	Gamestate.update(dt)
end

function love.keypressed(key, u)
   --Debug
   if key == "rctrl" then --set to whatever key you want to use
      debug.debug()
   end
end

function love.keypressed(key)
	if key == "rctrl" then
		debug.debug()
	else
		Gamestate.keypressed(key)
	end
end

function love.draw()
	--pass
	Gamestate.draw()
	trace.draw()
end