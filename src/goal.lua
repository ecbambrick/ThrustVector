require "lib.classlib"
require "radar"
require "explosion"

class.Goal()

--==============================================================================
-- Constructor
--==============================================================================
function Goal:__init(parent, x, y, x1, y1, x2, y2)

	-- parent
	self.parent = parent

	-- Initialize properties
	self.radar = RadarBlip(parent:getRadar(), self, 16, COLOR_LIME)
	self.radius = 2000	-- amount the goal can move when respawning
	
	-- pulse (changing the size of the goal) parameters
	self.outerSize = { min = 4, max = 32, curr = 16 }
	self.innerSize = { min = 6,  max = 12, curr = 8  }
	self.pulseDir = 1
	self.timer = 0
	self.interval = 1
	
	-- Initialize physics and collision detection
	local width			= 120
	local height		= 120
	local maxSpeed		= self.parent.body.velMax
	local acceleration	= 0
	local friction		= 0
	
	self.body = Body(self, x, y, width, height, maxSpeed, acceleration, 
		friction, torque)
	
	if x1 and x2 and y1 and y2 then self:setBoundaries(x1, y1, x2, y2) end
	
end

--==============================================================================
-- Update
--==============================================================================
function Goal:update(dt)
	-- update timer
	if self.pulseDir == 1 then self.timer = self.timer + dt
	elseif self.pulseDir == 0 then self.timer = self.timer - dt end
	
	-- resize goal
	local innerDifference = self.innerSize.max - self.innerSize.min
	local outerDifference = self.outerSize.max - self.outerSize.min
	local timerAdjustment = self.timer * ( 1 / self.interval )
	self.innerSize.curr = self.innerSize.min + timerAdjustment * innerDifference
	self.outerSize.curr = self.outerSize.min + timerAdjustment * outerDifference
	
	-- determine if the goal should expand or contract
	if self.timer > self.interval then self.pulseDir = 0 end
	if self.timer < 0 then self.pulseDir = 1 end
end

--==============================================================================
-- Draw
--==============================================================================
function Goal:draw()
	love.graphics.push()
	love.graphics.translate(self.body.x, self.body.y)
	love.graphics.rotate(self.body.angle + math.pi/2)
	love.graphics.setColor(COLOR_LIME)
	love.graphics.circle('line', 0, 0, self.outerSize.curr)
	love.graphics.circle('line', 0, 0, self.innerSize.curr)
	love.graphics.circle('fill', 0, 0, self.innerSize.curr)
	love.graphics.pop()
end

--==============================================================================
-- Actions
--==============================================================================
function Goal:capture()
	
	-- position infront of player
	local a		= player.body.angle - math.pi/4
	local b		= player.body.angle + math.pi/4
	local angle = math.random(a,b) + math.pi
	
	-- create particle effect
	HealthUp(self.body.x, self.body.y, 0)
	
	-- move to new area
	self.body.x = player:getX() - (self.radius * math.cos(angle))
	self.body.y = player:getY() - (self.radius * math.sin(angle))
	self.body:updateShape()
	player:incrementScore()
	
end

--==============================================================================
-- Setters and getters
--==============================================================================
function Goal:setBoundaries(x1, y1, x2, y2)
	local r = self.radar.radius
	self.body:setBoundaries(x1+r, y1+r, x2-r, y2-r)
end

function Goal:getX() return self.body:getX() end
function Goal:getY() return self.body:getY() end
function Goal:getAngle() return self.body.angle end