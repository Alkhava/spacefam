local Gamestate = require 'gamestate'
local window = require 'window'

local screen = Gamestate.new()

function screen:init()
	--pass
end

function screen:enter()
	self.message = ""
	self.progress = 0
	self.time = 0
	self.splash = love.graphics.newImage('spacefam.jpg')
end

function screen:update(dt)
	self.time = self.time + dt

	if self.time < 3 then
		self.message = 'Testing'
		return
	end

	Gamestate.switch('welcome')
end

function screen:keypressed() -- Skip test update
	self.time = 5
end

function screen:leave()
	love.graphics.setColor(255,255,255,255)
	self.splash = nil
end

function screen:draw()
	love.graphics.setColor(255,255,255,math.min(255, self.time * 100))
	love.graphics.draw(self.splash, window.width/2 - self.splash:getWidth()/2, window.height/2 - self.splash:getHeight()/2)

	if self.time > 0 then
		love.graphics.rectangle('line', 40, window.height - 75, window.width - 80, 10)
		love.graphics.rectangle('fill', 40, window.height - 75, (window.width - 80) * self.time / 3, 10)
		--love.graphics.print(self.message, window.width/2 - 30, window.height/2)
	end
end

return screen

