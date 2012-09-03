require "lib.classlib"

--==============================================================================
-- Laser
--==============================================================================
class.Laser()

function Laser:__init(parent, rateOfFire)
	self.parent = parent
	self.rateOfFire = 1--rateOfFire or 1
	self.timer = 0
	self.shooting = false
	
	self.body = Body(self, parent:getY(), parent:getY(), 4, 400, 0, 0, 0, 0)
	
	scene:addObject(self)
	
end

function Laser:update(dt)

	self.timer = self.timer + dt
	self.shooting = false
	
	-- [ INPUT ] Shoot
	if love.keyboard.isDown("z") then self.shooting = true end

	local angle = self.parent:getAngle() + math.pi/2
	local x = self.parent:getX() + self.body.height/2*math.cos(self.parent:getAngle())
	local y = self.parent:getY() + self.body.height/2*math.sin(self.parent:getAngle())
	self.body:setPosition(x,y)
	self.body:setAngle(angle)
	self.body:updateShape()
	
	if self.shooting then
	end
	
end

function Laser:draw()
	if self.shooting then
		love.graphics.setColor(255,255,255)
		self.body.shape:draw("fill")
	end
	self.shooting = false
end

function Laser:shoot()
	self.shooting = true
end

--==============================================================================
-- bullet
--==============================================================================
class.Bullet()

function Bullet:__init(parent, x, y, angle)
	
	self.parent = parent
	self.body = Body(self, x, y, 32, 32, 1500, 10000000, 0, 0)
	self.body.angle = angle
	
end

function Bullet:update(dt)
	self.body:applyAcceleration(dt)
	self.body:applyFriction(dt)
	self.body:applyVelocity(dt)
	self.body:updateShape()
	self:checkDeath()
end

function Bullet:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.circle("fill", self.body.x, self.body.y, 2)
end

function Bullet:checkDeath()
	if self.body:getDistanceFrom(self.parent) > 1000 then
		scene:removeObject(self)
		collider:remove(self.body.shape)
	end
end

function Bullet:die()
	scene:removeObject(self)
	collider:remove(self.body.shape)
end