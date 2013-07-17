--[[----------------------------------------------------------------------------

	Copyright (C) 2013 by Cole Bambrick
	cole.bambrick@gmail.com

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see http://www.gnu.org/licenses/.

--]]----------------------------------------------------------------------------

require "lib.classlib"

class.Body()

--==============================================================================
-- Body: Constructor
--==============================================================================
function Body:__init(parent, x, y, width, height, velMax, accel, frict, 
						torque)
	
	-- Parent
	self.parent = parent
	
	-- Positioning
	self.x			= x
	self.y			= y
	self.width		= width
	self.height		= height
	self.angle		= 0
	self.bounds		= {}
	
	-- Movement
	self.velX		= 0
	self.velY		= 0
	self.velMax		= velMax or 500
	self.torque		= torque or 5
	self.accel		= accel or 1500
	self.frict		= frict or 200
	
	-- Collision box
	self.shape = collider:addRectangle(x, y, self.width, self.height)
	self.shape.parent = parent
	
end

--==============================================================================
-- Body: Useful junk
--==============================================================================

function Body:updateShape()
	self.shape:moveTo(self.x,self.y)
	self.shape:setRotation(self.angle)
end

-- Increase velocity by acceleration
function Body:applyAcceleration(dt)
	self.velX = self.velX + self.accel * dt * math.cos(self.angle)
	self.velY = self.velY + self.accel * dt * math.sin(self.angle)
end

-- Slow down by friction
function Body:applyFriction(dt)
	local magnitude = math.sqrt(self.velX^2 + self.velY^2)
	local drag =  math.max(0, math.min(magnitude-self.frict*dt, self.velMax))
	if (magnitude > 0) then
		self.velX = self.velX * drag / magnitude
		self.velY = self.velY * drag / magnitude
	else
		self.velX = 0
		self.velY = 0
	end
end

-- Move by velocity
function Body:applyVelocity(dt)
	self.x = self.x + self.velX * dt 
	self.y = self.y + self.velY * dt 
end

-- Stay within bounds
function Body:checkBounds()
	if self.bounds.x2 > 0 then
		if (self.x < self.bounds.x1) then self.x = self.bounds.x1 end
		if (self.x > self.bounds.x2) then self.x = self.bounds.x2 end
	end
	if self.bounds.y2 > 0 then
		if (self.y < self.bounds.y1) then self.y = self.bounds.y1 end
		if (self.y > self.bounds.y2) then self.y = self.bounds.y2 end
	end
end

-- Change rotation to face an object
function Body:faceObject(object)
	local x1 = self.x
	local y1 = self.y
	local x2 = object:getX()
	local y2 = object:getY()
	self.angle = math.atan2(y2 - y1, x2 - x1)
end

-- Change rotation to face away from an object
function Body:faceAwayFromObject(object)
	local x1 = self.x
	local y1 = self.y
	local x2 = object:getX()
	local y2 = object:getY()
	self.angle = math.atan2(y1 - y2, x1 - x2)
end

-- Rotate by rotational velocity
function Body:rotateLeft(dt)
	self.angle = self.angle - self.torque * dt
end

function Body:rotateRight(dt)
	self.angle = self.angle + self.torque * dt
end

--==============================================================================
-- Setters
--==============================================================================
function Body:setBoundaries(x1, y1, x2, y2)
	self.bounds = {}
	self.bounds.x1 = x1
	self.bounds.y1 = y1
	self.bounds.x2 = x2
	self.bounds.y2 = y2
end

function Body:setPosition(x, y)
	self.x = x
	self.y = y
end

function Body:setAngle(rot)
	self.angle = rot
end

--==============================================================================
-- Getters
--==============================================================================
function Body:getDistanceFrom(object)
	return math.sqrt(
		(self:getX() - object:getX()) * (self:getX() - object:getX())
	  + (self:getY() - object:getY()) * (self:getY() - object:getY())
	)
end

function Body:getAnglebetween(object)
	return math.atan2(object:getY() - self.y, object:getX() -  self.x)
end

function Body:getVelocity()
	return math.sqrt(self.velX^2 + self.velY^2)
end

function Body:getX() return self.x end
function Body:getY() return self.y end
function Body:getAngle() return self.angle end
function Body:getMaxVelocity() return self.velMax end

