require "lib.classlib"
require "explosion"

class.Missile2()

-- Colors
local orange = {255, 205, 50, 255}
local red = {255, 0, 0, 255}
local white	= {255, 255, 255, 255}

--==============================================================================
-- Constructor
--==============================================================================
function Missile2:__init(x,y)

	-- Initialize image
	self.image = love.graphics.newImage("res/Missile.png")
	self.image:setFilter("nearest", "nearest")
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
	
	-- Initialize collision entity
	self.shape = collider:addRectangle(x, y, self.width, self.height)
	self.shape.parent = self

	-- Initialize misc propertiers
	self.x = x or 0
	self.y = y or 0
	self.angle = 0
	
	self.circleSize = 8
	self.circleX = 0
	self.circleY = 0
	
	-- Initilaize physics properties
	self.vel = {x=0, y=0, max=1200}
	self.accel = 2000
	self.frict = 250
	self.angle = 0
	self.maxLife = 10
	self.life = self.maxLife
	self.color = COLOR_RED
	
	
	
	
	self.path = {}
	
end

--==============================================================================
-- Update
--==============================================================================
function Missile2:update(dt)

	table.insert(self.path, {x=self.x, y=self.y})
	if #self.path > 100 then table.remove(self.path, 1) end

	self.life = self.life - 1 * dt
	if self.life <= 0 then
		scene:removeObject(self)
		return
	end

	-- Update radar blit thing
	local withinCircle = math.sqrt( (self.x - player:getX()) * (self.x - player:getX()) + (self.y - player:getY()) * (self.y - player:getY()) ) < ( player.radar.radius )
	if not withinCircle then
		local angle = math.atan2(player:getY() - self.y, player:getX() -  self.x)
		self.circleX = player:getX() - (player.radar.radius * math.cos(angle))
		self.circleY = player:getY() - (player.radar.radius * math.sin(angle))
	else
		self.circleX = self.x
		self.circleY = self.y
	end
	
	-- asdasdka;lskd;laskd;lsakd;la!
	--[[
	local angle1 = self.angle
	self:facePlayer(dt)
	local angle2 = self.angle
	self.angle = angle1
	if math.abs(angle1 - angle2) < math.pi then
		self.angle = angle2
	end
	--]]
	
	--asddsadsa
	self.color = COLOR_TEAL
	if self.life >= 5 then
		if self.life < self.maxLife - 1 * dt then self:facePlayer(dt)
		else self.angle = math.random(0,math.pi*2) end
		self.color = COLOR_RED
	end
	
	self.vel.x = self.vel.x + self.accel * dt * math.cos(self.angle)
	self.vel.y = self.vel.y + self.accel * dt * math.sin(self.angle)
	
	-- Apply friction
	local magnitude = math.sqrt(self.vel.x^2 + self.vel.y^2)
	local drag =  math.max(0, math.min(magnitude-self.frict*dt, self.vel.max))
	self.vel.x = self.vel.x * drag / magnitude
	self.vel.y = self.vel.y * drag / magnitude
	
	-- Move
	self.x = self.x + self.vel.x * dt
	self.y = self.y + self.vel.y * dt 
	
	self.shape:moveTo(self.x,self.y)
	
	
	if self:atPlayer() then self:explode() end
	
end

--==============================================================================
-- Draw
--==============================================================================
function Missile2:draw()

	local prev = {}
	for i,v in pairs(self.path) do
		if i ~= 1 then
			love.graphics.setColor(white)
			love.graphics.line(prev.x, prev.y, v.x, v.y)
		end
		prev = {x=v.x, y=v.y}
	end

	-- Draw enemy radar position
	local derp = math.sqrt( (self.x - player:getX()) * (self.x - player:getX()) + (self.y - player:getY()) * (self.y - player:getY()) ) / 200
	if derp < player.radar.radius/200 then derp = 1 end
	love.graphics.setColor(self.color)
	love.graphics.circle("line",self.circleX,self.circleY,self.circleSize/derp)
	
	-- Draw enemy sprite
	love.graphics.push()
	love.graphics.translate(self.x, self.y)
	love.graphics.rotate(self.angle+1.6)
	love.graphics.setColor(COLOR_ORANGE)
	--love.graphics.draw(self.image, -self.width/2, -self.height/2)
	love.graphics.rectangle("fill", -self.width, -self.height, self.width, self.height)
	love.graphics.pop()
	
end


--==============================================================================
-- Actions
--==============================================================================
function Missile2:facePlayer()
	local x1 = self.x
	local y1 = self.y
	local x2 = player:getX()
	local y2 = player:getY()
	self.angle = math.atan2(y2 - y1, x2 - x1)
	
	--if math.abs(angle - self.angle) < math.pi then self.angle = angle end
	
end

function Missile2:atPlayer()
	local withinCircle = math.sqrt( (self.x - player:getX()) * (self.x - player:getX()) + (self.y - player:getY()) * (self.y - player:getY()) ) < ( player.body.width )
	
	if withinCircle then return true
	else return false end
end

function Missile2:explode()
	self.life = 0
	player:decrementHealth()
	explosion = Explosion(player:getX(), player:getY(), self.angle)
	camera:shake()
end

function Missile2:die()
	self.life = 0
end