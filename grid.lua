local Gamestate = require 'gamestate'
local window = require 'window'
local menu = require 'menu'
require 'trace'

local grid = Gamestate.new()

function grid:init()
	self.name = 'grid'
	self.check1 = false
	self.check2 = false
	self.check3 = false
	self.check4 = false
	self.alg = 'Default'
end

function grid:enter(previous, alg, nPlayers, gridType)
	self.previous = previous
	self.alg = alg
	self.gridType = gridType
	self.nPlayers = nPlayers

	self.menu = menu.new({'rot1', 'rot2', 'rot3', 'rot4', 'Table', 'Algorithm', 'Restart' ,'Exit'})
	self.menu:onSelect(function(option)
		if option == 'Exit' then
			love.event.push("quit")
		elseif option == 'rot1' then
			self.check1 = not self.check1
		elseif option == 'rot2' then
			self.check2 = not self.check2
		elseif option == 'rot3' then
			self.check3 = not self.check3
		elseif option == 'rot4' then
			self.check4 = not self.check4
		elseif option == 'Table' then
			self.pileA = initTable(self.gridType, self.nPlayers, self.array[6])
		elseif option == 'Algorithm' then
			self.pileA = initParams(self.nPlayers, self.array[6])
		elseif option == 'Restart' then
			Gamestate.switch("update")
		end
	end)

	self.arrow = love.graphics.newImage('small_arrow.png')

	if self.gridType == "gridA" then self.array = polarGridA(self.nPlayers) end
	if self.gridType == "gridB" then self.array = polarGridB(self.nPlayers) end
	if self.gridType == "gridC" then self.array = polarGridC(self.nPlayers) end

	if self.alg == 'Algorithm' then self.pileA = initParams(self.nPlayers, self.array[6]) end
	if self.alg == 'Table' then self.pileA = initTable(self.gridType, self.nPlayers, self.array[6]) end

end

function grid:update(dt)
	-- pass
end

function grid:draw()
	love.graphics.draw(self.arrow, 12, 23 + 12 * (self.menu:selected() - 1))
	for n,option in ipairs(self.menu.options) do
		if option == 'rot1' then 
			self.text = 'Rotate Ring 1' 
		elseif option == 'rot2' then 
			self.text = 'Rotate Ring 2'
		elseif option == 'rot3' then 
			self.text = 'Rotate Ring 3'
		elseif option == 'rot4' then 
			self.text = 'Rotate Ring 4'
		elseif option == 'Table' then
			self.text = 'Table Shuffle'
		elseif option == 'Algorithm' then
			self.text = 'Algorithm Shuffle'
		else
			self.text = option
		end

		love.graphics.print(self.text, 23, 12 * n - 2)
	end

	drawPolarGrid(self.array[1], self.array[2], self.array[3], self.array[4], self.array[5], self.pileA, self.check1, self.check2, self.check3, self.check4) -- grid
end

function grid:keypressed(key)
	self.menu:keypressed(key)
end

function grid:leave()
	self.text = nil
	self.check1 = false
	self.check2 = false
	self.check3 = false
	self.check4 = false
	self.menu.selection = 0
end

function polarGridA(nPlayers)
	if (nPlayers == 3 or nPlayers == 4) then
		nRings = 3
		ringOne = 4
		ringTwo = 8
		ringThree = 16
		ringFour = nil
		nTiles = ringOne + ringTwo + ringThree
	elseif nPlayers == 5 or nPlayers == 6 then
		nRings = 4
		ringOne = 4
		ringTwo = 8
		ringThree = 16
		ringFour = 16
		nTiles = ringOne + ringTwo + ringThree + ringFour
	end

	return {nRings, ringOne, ringTwo, ringThree, ringFour, nTiles}
end

function polarGridB(nPlayers)
	if nPlayers == 3 then
		nRings = 3
		ringOne = 4
		ringTwo = 8
		ringThree = 12
		ringFour = nil
		nTiles = ringOne + ringTwo + ringThree
	elseif nPlayers == 4 or nPlayers == 5 then
		nRings = 4
		ringOne = 4
		ringTwo = 8
		ringThree = 12
		ringFour = 16
		nTiles = ringOne + ringTwo + ringThree + ringFour
	elseif nPlayers == 6 then
		nRings = 4
		ringOne = 4
		ringTwo = 8
		ringThree = 12
		ringFour = 20
		nTiles = ringOne + ringTwo + ringThree + ringFour
	end

	return {nRings, ringOne, ringTwo, ringThree, ringFour, nTiles}
end

function polarGridC(nPlayers)
	if (nPlayers == 3 or nPlayers == 4) then
		nRings = 3
		ringOne = 4
		ringTwo = 8
		ringThree = 16
		ringFour = nil
		nTiles = ringOne + ringTwo + ringThree
	elseif nPlayers == 5 or nPlayers == 6 then
		nRings = 4
		ringOne = 6
		ringTwo = 12
		ringThree = 24
		ringFour = nil
		nTiles = ringOne + ringTwo + ringThree
	end

	return {nRings, ringOne, ringTwo, ringThree, ringFour, nTiles}
end


function drawPolarGrid(nRings, ringOne, ringTwo, ringThree, ringFour, pileA, rot1_check, rot2_check, rot3_check, rot4_check)
	tiles = 0
	r0 = 10
	r1 = 80 -- Check this value
	r2 = 2 * r1
	r3 = 3 * r1
	r4 = 4 * r1
	rot1 = 0
	rot2 = 0
	rot3 = 0
	rot4 = 0
	x0 = love.graphics:getWidth()/2
	y0 = love.graphics:getHeight()/2
	--First, draw the origin circle
	love.graphics.setColor(255,255,255)
	love.graphics.circle("line",x0,y0, r0, 100)
	-- Draw ringOne
	love.graphics.circle("line",x0,y0,r1,100)
	dq = (360.0/ringOne)*(math.pi/180.0)
	if rot1_check then rot1 = dq/2 end
	for i = 0,ringOne-1 do
		love.graphics.line(x0+r0*math.cos(i*dq + rot1),y0+r0*math.sin(i*dq + rot1),x0+r1*math.cos(i*dq + rot1),y0+r1*math.sin(i*dq + rot1))
		tiles = tiles + 1
		love.graphics.print(pileA[tiles],x0+((r1+r0)/2)*math.cos(i*dq+(dq/2)+ rot1)-5, y0+((r0+r1)/2)*math.sin(i*dq+(dq/2) + rot1)-5)
	end
	-- Draw ringTwo
	love.graphics.circle("line",x0,y0,r2,100)
	dq = (360.0/ringTwo)*(math.pi/180.0)
	if rot2_check then rot2 = dq/2 end
	for i = 1,ringTwo do
		love.graphics.line(x0+r1*math.cos(i*dq + rot2),y0+r1*math.sin(i*dq + rot2),x0+r2*math.cos(i*dq + rot2),y0+r2*math.sin(i*dq + rot2))
		tiles = tiles + 1
		love.graphics.print(pileA[tiles],x0+((r2+r1)/2)*math.cos(i*dq+(dq/2) + rot2)-5, y0+((r1+r2)/2)*math.sin(i*dq+(dq/2) + rot2)-5)
	end
	-- Draw ringThree
	love.graphics.circle("line",x0,y0,r3,100)
	dq = (360.0/ringThree)*(math.pi/180.0)
	if rot3_check then rot3 = dq/2 end
	for i = 0,ringThree-1 do
		love.graphics.line(x0+r2*math.cos(i*dq + rot3),y0+r2*math.sin(i*dq + rot3),x0+r3*math.cos(i*dq + rot3),y0+r3*math.sin(i*dq + rot3))
		tiles = tiles + 1
		love.graphics.print(pileA[tiles],x0+((r2+r3)/2)*math.cos(i*dq+(dq/2) + rot3)-5, y0+((r2+r3)/2)*math.sin(i*dq+(dq/2) + rot3)-5)
	end
	-- Draw ringFour if necessary
	if (ringFour ~= nil) then
		love.graphics.circle("line",x0,y0,r4,100)
		dq = (360.0/ringFour)*(math.pi/180.0)
		if rot4_check then rot4 = dq/2 end
		for i = 0,ringFour-1 do
			love.graphics.line(x0+r3*math.cos(i*dq + rot4),y0+r3*math.sin(i*dq + rot4),x0+r4*math.cos(i*dq + rot4),y0+r4*math.sin(i*dq + rot4))
			tiles = tiles + 1
			love.graphics.print(pileA[tiles],x0+((r3+r4)/2)*math.cos(i*dq+(dq/2) + rot4)-5, y0+((r3+r4)/2)*math.sin(i*dq+(dq/2) + rot4)-5)
		end
	end
end

function initTable(gridType, nPlayers, nTiles)
	if gridType == 'gridA' then
		if nPlayers == 3 or nPlayers == 4 then
			n1 = 1
			n2 = 4
			n3 = 1
		elseif nPlayers == 5 or nPlayers == 6 then
			n1 = 2
			n2 = 5
			n3 = 2
		end
	elseif gridType == 'gridB' then
		if nPlayers == 3 then
			n1 = 1
			n2 = 3
			n3 = 1
		elseif nPlayers == 4 or nPlayers == 5 then
			n1 = 2
			n2 = 4
			n3 = 3
		elseif nPlayers == 6 then
			n1 = 2
			n2 = 6
			n3 = 2
		end
	elseif gridType == 'gridC' then
		if nPlayers == 3 or nPlayers == 4 then
			n1 = 1
			n2 = 4
			n3 = 1
		elseif nPlayers == 5 or nPlayers == 6 then
			n1 = 2
			n2 = 5
			n3 = 2
		end
	end

	pileA = {}

	for i = 1, n1 do
		pileA[#pileA+1] = 1
	end

	for i = 1, n2 do
		pileA[#pileA+1] = 2
	end

	for i = 1, n3 do
		pileA[#pileA+1] = 3
	end

	for i = 1, nTiles-#pileA do
		pileA[#pileA+1] = ' '
	end

	pileA = shuffle(pileA)

	return pileA
end

function initParams(nPlayers, nTiles)
	if nPlayers == 3 then
		minS = 8
		maxS = 8
		minCB = 2
		maxCB = 8
		dS = maxS - minS
		dCB = maxCB - minCB
	elseif nPlayers == 4 or nPlayers == 5 then
		minS = 12
		maxS = 15
		minCB = 4
		maxCB = 10
		dS = maxS - minS
		dCB = maxCB - minCB
	elseif nPlayers >= 6 then
		minS = 16
		maxS = 24
		minCB = 10
		maxCB = 20
		dS= maxS - minS
		dCB = maxCB - minCB
	end 

	pileA = {}
	pileB = {}

	for i = 1,maxS,1 do
		if i <= minS then
			pileA[#pileA+1] = "S"
		else
			pileB[#pileB+1] = "S"
		end
	end

	for i = 1,maxCB,1 do
		if i <= minCB then
			pileA[#pileA+1] = " "
		else
			pileB[#pileB+1] = " "
		end
	end

	for i = 1, nTiles-#pileA do
		pileB[#pileB+1] = " "
	end

	pileB = shuffle(pileB)

	for i = 1, #pileB do
		pileA[#pileA+1] = pileB[i]
	end

	pileA = shuffle(pileA)

	for i = 1, #pileA do
		if pileA[i] == "S" then
			pileA[i] = numP()
		end
	end

	return pileA

end

function shuffle(t)
	it = #t
	math.randomseed(os.time())

	for i = it,2,-1 do
		j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end

	return t
end

function numP()
	rnd = math.random()
	if rnd < 0.25 then p = 1 end
	if rnd <= 0.75 and rnd >= 0.25 then p = 2 end
	if rnd > 0.75 then p = 3 end

	return p
end

return grid
