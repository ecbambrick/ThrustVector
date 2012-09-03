require "lib.classlib"

class.Camera()

--==============================================================================
-- Constructor
--	focal is the object the camera will try to follow
--	mode is the behaviour the camera will have in relation to the focal
--==============================================================================
function Camera:__init(x, y, scale, rotation, focal, mode)
		self.x = x or 0
		self.y = y or 0
		self.scale = scale or 1
		self.rotation = rotation or 0
		self.bounds = nil
		self.focal = focal or nil
		self.mode = mode or "static"
		self.timer = 0
		self.shaking = false
		
		self.body = Body(self, x, y, 1, 1, 5000, 4000, 3000, 0)
end

--==============================================================================
-- Push/pop camera transformations to/from graphics stack
--==============================================================================
function Camera:update(dt)

	-- Focus center of camera on focal object
	if self.focal and self.mode == "follow" then
		local x = self.focal:getX() - WINDOW_WIDTH/2 * self.scale
		local y = self.focal:getY() - WINDOW_HEIGHT/2 * self.scale
		self:setPosition(x,y)
	end
	
	self.body:faceObject(player)
	self.body:applyAcceleration(dt)	-- updates velocity
	self.body:applyFriction(dt)		-- updates velocity
	self.body:applyVelocity(dt)		-- updates position
	self.body:updateShape()			-- updates collision box
	
	self.x = self.body.x - 400
	self.y = self.body.y - 300
	
	-- Reposition camera within bounds
	if self.bounds then
		if self.x < self.bounds.x1 then self.x = self.bounds.x1 end
		if self.x > self.bounds.x2 then self.x = self.bounds.x2 end
		if self.y < self.bounds.y1 then self.y = self.bounds.y1 end
		if self.y > self.bounds.y2 then self.y = self.bounds.y2 end
	end
	
	-- shake 
	if self.shaking then
		if self.timer < 1 then
			self.x = self.x + math.random(-1,1)/self.timer
			self.y = self.y + math.random(-1,1)/self.timer
			self.timer = self.timer + dt
		else
			self.shaking = false
			self.timer = 0
		end
	end
end

function Camera:set()
	love.graphics.push()
	love.graphics.rotate(-self.rotation)
	love.graphics.scale(self.scale, self.scale)
	love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
	love.graphics.pop()
end

--==============================================================================
-- Actions
--==============================================================================
function Camera:shake()
	self.shaking = true
	self.timer = 0
end

--==============================================================================
-- Setters
--==============================================================================
function Camera:setPosition(x, y)
	self.x = x or self.x
	self.y = y or self.y
end

function Camera:setBoundaries(x1,y1,x2,y2)
	self.bounds = {}
	self.bounds.x1 = x1 / self.scale
	self.bounds.y1 = y1 / self.scale
	self.bounds.x2 = (x2 - love.graphics.getWidth()) / self.scale
	self.bounds.y2 = (y2 - love.graphics.getHeight()) / self.scale
end

--==============================================================================
-- Getters
--==============================================================================
function Camera:getMouseX() return love.mouse.getX() / self.scale + self.x end
function Camera:getMouseY() return love.mouse.getY() / self.scale + self.y end
function Camera:getRelativeX(object) return object:getX() / self.scale + self.y end
function Camera:getRelativeX(object) return object:getY() / self.scale + self.x end