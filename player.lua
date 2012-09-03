require "lib.classlib"
require "components.fireable"
require "components.laser"
require "physics"
require "token"

class.Player()

--==============================================================================
-- Constructor
--==============================================================================
function Player:__init(x, y, x1, y1, x2, y2)

	-- Initialize properties
	self.health = 3
	self.score = 0
	self.highScore = 0
	self.maxHealth = 3
	self.color = COLOR_TEAL

	-- Initialize physics and collision detection
	self.minTorque = 2
	self.maxTorque = 6
	
	local width			= 24
	local height		= 24
	local maxSpeed		= 800
	local acceleration	= 4000
	local friction		= 700
	local torque		= self.minTorque
	
	self.body = Body(self, x, y, width, height, maxSpeed, acceleration, 
		friction, torque)
	
	if x1 and x2 and y1 and y2 then self:setBoundaries(x1, y1, x2, y2) end
	
	-- Initialize components
	self.tail = Tail(self, COLOR_TEAL)
	self.radar = Radar(60, COLOR_TEAL)
	self.fireable = Laser(self)
	
end

--==============================================================================
-- Update
--==============================================================================
function Player:update(dt)

	local defaultTorque = self.body.torque
	local defaultFriction = self.body.frict
	
	-- Torque changes depending on the the velocity
	self.body.torque = -self.body:getVelocity()
						* (self.maxTorque-self.minTorque)
						/ self.body:getMaxVelocity()
						+ self.maxTorque
	
	-- [ INPUT ] Slow down
	if love.keyboard.isDown("down") or love.keyboard.isDown("lshift") then
		self.body.frict = 1500 
	end
	
	-- [ INPUT ] Move Forward
	if love.keyboard.isDown("up") then self.body:applyAcceleration(dt) end
	
	-- [ INPUT ] Rotate
	if love.keyboard.isDown("left") then self.body:rotateLeft(dt)
	elseif love.keyboard.isDown("right") then self.body:rotateRight(dt) end
	
	-- Apply passive physics (friction and boundaries) and update collision
	self.body:applyFriction(dt)		-- updates velocity
	self.body:applyVelocity(dt)		-- updates position
	self.body:updateShape()			-- updates collision box
	
	-- Update tail and radar
	self.tail:update(dt, self:getTailPosition())
	self.radar:update(dt, self:getX(), self:getY())
	self.fireable:update(dt)
	
	self.body.torque = defaultTorque
	self.body.frict = defaultFriction
	
end

--==============================================================================
-- Draw
--==============================================================================
function Player:draw()

	-- Draw misc
	self.tail:draw()
	self.radar:draw()
	self.fireable:draw()
	
	-- Draw sprite
	love.graphics.push()
	love.graphics.translate(self.body.x, self.body.y)
	love.graphics.rotate(self.body.angle + math.pi/2)
	love.graphics.setColor(self.color)
	love.graphics.polygon('line', 0, -16, -8, 16, 8, 16)
	
	-- Draw Health
	if self.health == 3 then
		love.graphics.polygon('fill', 0, -16, -8, 16, 8, 16)
	elseif self.health == 2 then
		love.graphics.polygon('fill', 4, 0, -4, 0, -8, 16, 8, 16)
	end
	
	love.graphics.pop()

end

--==============================================================================
-- Actions
--==============================================================================
function Player:decrementHealth()
	self.health = self.health - 1
	if self.health == 0 then self:die() end
end

function Player:incrementHealth()
	if self.health < self.maxHealth then self.health = self.health + 1 end
end

function Player:incrementScore()
	self.score = self.score + 1
	if self.score > self.highScore then self.highScore = self.score end
	DEBUGMSG = "score: " .. self.score .. "\nhigh score: " .. self.highScore
end

function Player:die()
	self.health = 3
	self.score = 0
	DEBUGMSG = "score: " .. self.score .. "\nhigh score: " .. self.highScore
end


--==============================================================================
-- Setters and getters
--==============================================================================
function Player:setBoundaries(x1, y1, x2, y2)
	local r = self.radar.radius
	self.body:setBoundaries(x1+r, y1+r, x2-r, y2-r)
end

function Player:getTailPosition()
	return self:getX() - (16 * math.cos(self:getAngle())),
		   self:getY() - (16 * math.sin(self:getAngle()))
end

function Player:getX() return self.body:getX() end
function Player:getY() return self.body:getY() end
function Player:getAngle() return self.body.angle end
function Player:getRadar() return self.radar end