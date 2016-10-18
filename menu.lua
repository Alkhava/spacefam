local menu = {}
menu.__index = menu

function menu.new(options)
	local m = {}
	setmetatable(m, menu)
	m.options = options or {}
	m.handlers = {}
	m.selection = 0
	return m
end

function menu:onSelect(func)
	self.handlers['select'] = func
end

function menu:selected()
	return self.selection
end

function menu:keypressed(button)
	if button == "return" or button == "space" then
		local option = self.options[self.selection + 1]
		if self.handlers['select' ] then
			self.handlers['select'](option)
		end
	elseif button == "up" then
		self.selection = (self.selection - 1) % #self.options
	elseif button == "down" then
		self.selection = (self.selection + 1) % #self.options
	end
end

return menu
