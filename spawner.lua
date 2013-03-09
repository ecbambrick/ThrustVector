require "lib.classlib"
require "tail"
require "radar"
require "explosion"

class.Spawner()

--==============================================================================
-- Constructor
--==============================================================================
function Spawner:__init(radius, chance)

	self.radius = radius or 1000
	self.chance = chance or 1500
	self.timer  = 0
	
end

--==============================================================================
-- Update
--==============================================================================
function Spawner:update(dt)

	local fireMissile = false

	-- update timer
	self.timer = self.timer + dt
	if self.timer > 0.1 then 
		fireMissile = true
		self.timer = 0
	end

	-- Position missile behind player
	local a		= player.body.angle - math.pi/2
	local b		= player.body.angle + math.pi/2
	local angle = math.random(a,b)
	
	-- Position missile self.radius distance away
	local x		= player:getX() - (self.radius * math.cos(angle))
	local y		= player:getY() - (self.radius * math.sin(angle))
	
	-- Fire a missile
	if fireMissile and math.random(self.chance) == 1 then
		local missile = Missile(x,y)
		scene:addObject(missile)
	end
	
end

-- Nothing to draw, so leave this empty
function Spawner:draw() end





--------------------------------------------------------------------------------





class.Missile()

--==============================================================================
-- Constructor
--==============================================================================
function Missile:__init(x,y)

	-- Initialize properties
	self.color = COLOR_ORANGE
	self.timerDie = 7
	self.timerFollow = 5
	self.timer = 0

	-- Initialize components
	self.radar = RadarBlip(player:getRadar(), self, 16, COLOR_ORANGE)
	self.tail = Tail(self, COLOR_WHITE)

	-- Initialize physics and collision detection
	local width			= 4
	local height		= 16
	local maxSpeed		= 1200
	local acceleration	= 2500
	local friction		= 250
	local torque		= 0
	
	self.body = Body(self, x, y, width, height, maxSpeed, acceleration,
		friction, torque)

end

--==============================================================================
-- Update
--==============================================================================
function Missile:update(dt)

	self.timer = self.timer + dt
	
	-- Missile stops tracking player after timerFollow is reached
	if self.timer < self.timerFollow then
		self.body:faceObject(player)
		self:getRadar().color = COLOR_ORANGE
	else
		self:getRadar().color = COLOR_TEAL
	end
	
	-- Apply passive physics (friction and boundaries) and update collision
	self.body:applyAcceleration(dt)	-- updates acceleration
	self.body:applyFriction(dt)		-- updates velocity
	self.body:applyVelocity(dt)		-- updates position
	self.body:updateShape()			-- updates collision box
	
	-- Update tail and radar
	self.tail:update(dt, self:getTailPosition())
	self.radar:update(dt, self:getX(), self:getY())
	
	-- Missile dies without explosion after timerDie is reached
	if self.timer >= self.timerDie then
		self:die()
	end
	
end

--==============================================================================
-- Draw
--==============================================================================
function Missile:draw()
	
	-- Draw misc
	self.tail:draw()
	self.radar:draw()
	
	-- Draw sprite
	love.graphics.push()
	love.graphics.translate(self.body.x, self.body.y)
	love.graphics.rotate(self.body.angle + math.pi/2)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", -self.body.width/2, -self.body.height/2, 
		self.body.width/2, self.body.height/2)
	love.graphics.pop()
	
end

--==============================================================================
-- Actions
--==============================================================================
function Missile:explode(x,y,angle)
	explosion = Explosion(x,y,angle)
	self:die()
end

function Missile:die()
	self.radar:clean()
	collider:remove(self.body.shape)
	scene:removeObject(self)
end

--==============================================================================
-- Setters/Getters
--==============================================================================
function Missile:getTailPosition()
	return self:getX() - (2 * math.cos(self:getAngle())),
		   self:getY() - (2 * math.sin(self:getAngle()))
end

function Missile:getX() return self.body:getX() end
function Missile:getY() return self.body:getY() end
function Missile:getAngle() return self.body.angle end
function Missile:getRadar() return self.radar end
