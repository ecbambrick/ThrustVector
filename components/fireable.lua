require "lib.classlib"

--==============================================================================
-- Fireable
--==============================================================================
class.Fireable()

function Fireable:__init(parent, rateOfFire)
	self.parent = parent
	self.rateOfFire = rateOfFire or 100
	self.timer = 0
	self.shooting = false
end

function Fireable:update(dt)
	self.timer = self.timer + dt
end

function Fireable:draw()
end

function Fireable:shoot()
	if self.timer >= 1/self.rateOfFire then
		local angle = self.parent:getAngle() - math.pi/8 + math.random() * math.pi/4
		local x = self.parent:getX()
		local y = self.parent:getY()
		local bullet = Bullet(self.parent, x, y, angle)
		scene:addObject(bullet)
		self.timer = 0
	end
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