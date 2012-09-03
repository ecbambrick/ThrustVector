require "lib.classlib"

class.Enemy()

-- Colors
local teal	= {0, 255, 255, 255}
local red	= {255, 0, 0, 255}
local white	= {255, 255, 255, 255}


--==============================================================================
-- Constructor
--==============================================================================
function Enemy:__init(x,y)

	self.ai = math.random(1,2)

	-- Initialize image
	self.image = love.graphics.newImage("res/toxicicon.png")
	self.image:setFilter("nearest", "nearest")
	self.size = self.image:getWidth()
	
	-- Initialize collision entity
	self.shape = collider:addRectangle(x, y, self.size, self.size)
	self.shape.parent = self

	-- Initialize misc propertiers
	self.x = x or 0
	self.y = y or 0
	self.angle = 0
	self.color = teal
	
	self.circleSize = self.size
	self.circleX = 0
	self.circleY = 0
	
	-- Initialize states
	self.states = set {
		"free", "hover", "capturable", "capturing", "captured", "shot"
	}
	
	-- Initilaize physics properties
	self.vel = {x=0, y=0, max=math.random(300,500)}
	self.accel = 800
	self.frict = math.random(0, 300)
	self.angle = 0
	
	self.path = {}
	
end

--==============================================================================
-- Update
--==============================================================================
function Enemy:update(dt)

	table.insert(self.path, {x=self.x, y=self.y})
	if #self.path > 50 then table.remove(self.path, 1) end

	local chance = math.random(1500)
	if chance == 1 then
		local missile = Missile(self.x,self.y)
		table.insert(missiles, missile)
	end

	-- Update radar blit thing
	
	--asddsadsa
	self:facePlayer(dt)
	self.vel.x = self.vel.x + self.accel * dt * math.cos(self.angle)
	self.vel.y = self.vel.y + self.accel * dt * math.sin(self.angle)
	
	-- Apply friction
	local magnitude = math.sqrt(self.vel.x^2 + self.vel.y^2)
	local drag =  math.max(0, math.min(magnitude-self.frict*dt, self.vel.max))
	if (magnitude > 0) then
		self.vel.x = self.vel.x * drag / magnitude
		self.vel.y = self.vel.y * drag / magnitude
	else
		self.vel.x = 0
		self.vel.y = 0
	end
	
	-- Move
	self.x = self.x + self.vel.x * dt
	self.y = self.y + self.vel.y * dt 
	
	self.shape:moveTo(self.x,self.y)
	
end

--==============================================================================
-- Draw
--==============================================================================
function Enemy:draw()

	--[[local prev = {}
	love.graphics.setColor(0, 255, 255, 255)
	for i,v in pairs(self.path) do
		if i ~= 1 then
			love.graphics.line(prev.x, prev.y, v.x, v.y)
		end
		prev = {x=v.x, y=v.y}
	end]]

	-- Draw enemy radar position
	local derp = math.sqrt( (self.x - player:getX()) * (self.x - player:getX()) + (self.y - player:getY()) * (self.y - player:getY()) ) / 80
	if derp < player.radar.radius/80 then derp = 1 end
	love.graphics.setColor(self.color)
	
	-- draw missile
	love.graphics.circle("line",self.circleX,self.circleY,self.circleSize/derp)
	
	-- Draw enemy sprite
	love.graphics.push()
	love.graphics.translate(self.x, self.y)
	love.graphics.rotate(self.angle+1.6)
	love.graphics.setColor(white)
	love.graphics.draw(self.image, -self.size/2, -self.size/2)
	love.graphics.pop()
	
end


--==============================================================================
-- Actions
--==============================================================================
function Enemy:facePlayer(dt)
	local x1 = self.x
	local y1 = self.y
	local x2 = player:getX()
	local y2 = player:getY()
	
	if self.ai == 2  then x2 = camera:getMouseX() end
	if self.ai == 2  then xy = camera:getMouseY() end
	
	self.angle = math.atan2(y2 - y1, x2 - x1)
	
	for i,v in pairs(enemies) do
		local x2 = v.x
		local y2 = v.y
		local angle2 = math.atan2(y2-y1,x2-x1)
		if math.abs(self.angle - angle2) < 0.1 then self.angle = self.angle + 0.3 end
	end
	
end
