local Gamestate = require 'gamestate'
local window = require 'window'
local menu = require 'menu'

local state = Gamestate.new()

function state:init()
	self.name = 'algorithm'
	self.menu = menu.new({'Table', 'Algorithm', 'Exit'})
	self.menu:onSelect(function(option)
		if option == 'Exit' then
			love.event.push("quit")
		else
			Gamestate.switch('grid', option, self.nPlayers, self.gridType) -- this is what happens after a grid option is selected
		end
	end)
end

function state:enter(previous, nPlayers, gridType)
	self.nPlayers = nPlayers
	self.gridType = gridType
	self.arrow = love.graphics.newImage('small_arrow.png')
	self.splash = love.graphics.newImage('openingmenu.png') -- Placeholder menu image taken from Hawkthorne

	self.previous = previous
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

function state:keypressed(key)
	self.menu:keypressed(key)
end

function state:leave()
	self.menu.selection = 0
	self.splash = nil
	self.arrow = nil
end

return state