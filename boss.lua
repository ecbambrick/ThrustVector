require "lib.classlib"
require "physics"
require "token"

class.Boss()

--==============================================================================
-- Constructor
--==============================================================================
function Boss:__init(x,y)

	-- Initialize properties
	self.life = 10
	self.tail = Tail(COLOR_RED)
	self.radar = Radar(32, COLOR_RED)
	
	-- Initialize image
	self:loadSprite("res/paxship_01.gif")
	
	-- Initialize physics and collision detection
	local maxSpeed		= 600
	local acceleration	= 2500
	local friction		= 400
	local angleVelocity	= 3
	
	self.body = Body(self, x, y, self.width, self.height, maxSpeed,
		acceleration, friction, angleVelocity)
	
end

--==============================================================================
-- Update
--==============================================================================
function Boss:update(dt)

	local distanceFromPlayer = self.body:getDistanceFrom(player)
	DEBUGMSG = distanceFromPlayer
	
	local defaultVelMax = self.body.velMax

	-- [ STATE ] Run away from player
	if distanceFromPlayer < 1000 then
		self.body:faceAwayFromObject(player)
		self.body.velMax = 1200
	
	-- [ STATE ] Chase player
	elseif distanceFromPlayer > 1000 then
		self.body:faceObject(player)
		self.body.velMax = 600
	
	end
	
	self.body:applyAcceleration(dt)

	-- Apply passive physics (friction and boundaries) and update collision
	self.body:applyFriction(dt)		-- updates velocity
	self.body:applyVelocity(dt)		-- updates position
	self.body:checkBounds()			-- updates position
	self.body:updateShape()			-- updates collision box
	
	-- Update tail
	self.tail:update(dt, self:getX(), self:getY())
	
	-- Update radar
	local withinCircle = math.sqrt( (self:getX() - player:getX()) * (self:getX() - player:getX()) + (self:getY() - player:getY()) * (self:getY() - player:getY()) ) < ( player.radar.radius )
	local circleX = 0
	local circleY = 0
	if not withinCircle then
		local angle = math.atan2(player:getY() - self:getY(), player:getX() -  self:getX())
		circleX = player:getX() - (player.radar.radius * math.cos(angle))
		circleY = player:getY() - (player.radar.radius * math.sin(angle))
	else
		self.circleX = self.x
		self.circleY = self.y
	end
	local derp = math.sqrt( (self:getX() - player:getX()) * (self:getX() - player:getX()) + (self:getY() - player:getY()) * (self:getY() - player:getY()) ) / 60
	if derp < player.radar.radius/60 then derp = 1 end
	self.radar:update(dt, circleX, circleY, self.radar.radius/derp)
	
	
	
	
	
	self.body.velMax = defaultVelMax
	
end

--==============================================================================
-- Draw
--==============================================================================
function Boss:draw()

	-- Draw misc
	self.tail:draw()
	self.radar:draw()
	
	-- Draw sprite
	love.graphics.push()
	love.graphics.translate(self.body.x, self.body.y)
	love.graphics.rotate(self.body.angle + math.pi/2)
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.image, -self.width/2, -self.height/2)
	love.graphics.pop()

end

--==============================================================================
-- Helpers
--==============================================================================

function Boss:loadSprite(path)
	self.image = love.graphics.newImage(path)
	self.image:setFilter("nearest", "nearest")
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
end

--==============================================================================
-- Setters and getters
--==============================================================================
function Boss:setBoundaries(x1, y1, x2, y2)
	self.body:setBoundaries(x1, y1, x2, y2)
end

function Boss:getX() return self.body:getX() end
function Boss:getY() return self.body:getY() end
