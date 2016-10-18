local Gamestate = require 'gamestate'
local menu = require 'menu'
local window = require 'window'

local state = Gamestate.new()

function state:init()
	self.name = "welcome"
	self.menu = menu.new({'gridA', 'gridB', 'gridC', 'Exit'})
	self.menu:onSelect(function(option)
		if option == 'Exit' then
			love.event.push("quit")
		else
			Gamestate.switch('numPlayers', option) -- this is what happens after a grid option is selected
		end
	end)
end

function state:enter(previous)
	self.arrow = love.graphics.newImage('small_arrow.png')
	self.splash = love.graphics.newImage('openingmenu.png') -- Placeholder menu image taken from Hawkthorne

	self.previous = previous
end

function state:keypressed(key)
	self.menu:keypressed(key)
end

function state:update(dt)
	-- pass
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
		if option == 'gridA' then
			self.text = 'Grid Type A'
		elseif option == 'gridB' then
			self.text = 'Grid Type B'
		elseif option == 'gridC' then
			self.text = 'Grid Type C'
		else
			self.text = option
		end
		love.graphics.print(self.text, x + 23, y + 12 * n - 2)
	end

end

function state:leave()
	self.text = nil
	self.splash = nil
	self.arrow = nil
end

return state