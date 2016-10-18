local Gamestate = require 'gamestate'
local window = require 'window'
local menu = require 'menu'

local state = Gamestate.new()

function state:init()
	self.name = 'numPlayers'
	self.menu = menu.new({'3 Players', '4 Players', '5 Players', '6 Players', 'Exit'})
	self.menu:onSelect(function(option)
		if option == 'Exit' then
			love.event.push("quit")
		else
			if option == '3 Players' then self.nPlayers = 3 end
			if option == '4 Players' then self.nPlayers = 4 end
			if option == '5 Players' then self.nPlayers = 5 end
			if option == '6 Players' then self.nPlayers = 6 end
			Gamestate.switch('grid', self.nPlayers, self.gridType) -- this is what happens after a player option is selected
		end
	end)
end

function state:enter(previous, arg)
	self.arrow = love.graphics.newImage('small_arrow.png')
	self.splash = love.graphics.newImage('openingmenu.png') -- Placeholder image

	self.gridType = arg
	self.previous = previous
end

function state:keypressed(key)
	self.menu:keypressed(key)
end

function state:update(dt)
	--pass
end

function state:draw()
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle('fill', 0, 0, love.graphics:getWidth(), love.graphics:getHeight())
	love.graphics.setColor(255, 255, 255, 255)

	local x = window.width / 2 - self.splash:getWidth() / 2
	local y = window.height / 2 - self.splash:getHeight() / 2

	love.graphics.draw(self.splash, x, y)
	love.graphics.draw(self.arrow, x + 12, y + 23 + 12 * (self.menu:selected() - 1))
	for n,option in ipairs(self.menu.options) do
		love.graphics.print(option, x + 23, y + 12 * n - 2)
	end
end

function state:leave()
	self.splash = nil
	self.arrow = nil
end

return state		