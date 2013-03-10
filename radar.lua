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
class.Radar()
class.RadarBlip()

--==============================================================================
-- Constructor
--==============================================================================
function Radar:__init(radius, color)
	self.x = 0
	self.y = 0
	self.radius = radius or 16
	self.color = color or COLOR_TEAL
	self.blips = {}
end

--==============================================================================
-- Update
--==============================================================================
function Radar:update(dt, x, y)
	self.x = x
	self.y = y
	self:updateBlips(dt)
end

--==============================================================================
-- Draw
--==============================================================================
function Radar:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("line", self.x, self.y, self.radius)
	self:drawBlips()
end

--==============================================================================
-- Blip Functions
--==============================================================================
function Radar:addBlip(blip)
	table.insert(self.blips, blip)
end

function Radar:removeBlip(blip)
	for i,v in ipairs(self.blips) do
		if v == blip then
			table.remove(self.blips, i)
			return
		end
	end
end

function Radar:updateBlips(dt)
	for i,v in pairs(self.blips) do v:update(dt) end
end

function Radar:drawBlips()
	for i,v in pairs(self.blips) do v:draw() end
end

--==============================================================================
-- Setters/Getters
--==============================================================================
function Radar:getX()		return self.x		end
function Radar:getY()		return self.y		end
function Radar:getRadius()	return self.radius	end





--------------------------------------------------------------------------------





--==============================================================================
-- Constructor
--   parent = the radar this blip is attached to
--   object = the object this blip is tracking (ie - a missile)
--==============================================================================
function RadarBlip:__init(parent, object, radius, color)

	parent:addBlip(self)

	self.parent = parent
	self.object = object
	self.radius = radius or 16
	self.scale = 0
	self.color = color or COLOR_TEAL
	self.x = 0
	self.y = 0

end

--==============================================================================
-- Destructor
--==============================================================================
function RadarBlip:clean()
	self.parent:removeBlip(self)
end

--==============================================================================
-- Update
--==============================================================================
function RadarBlip:update(dt)
	self.x = self.object:getX()
	self.y = self.object:getY()
	local distance = math.sqrt(
		(self.x - self.parent:getX())^2 + (self.y - self.parent:getY())^2
	)
	local angle = math.atan2(
		self.parent:getY() - self.y, self.parent:getX() -  self.x
	)
	
	-- determine size of blip based on distance from target
	self.scale = distance / 80
	if self.radius/self.scale < 1 then self.scale = self.radius/2 end
	if self.scale < 1 then self.scale = 1 end
		
	-- if the parent is within the radar radius, then draw directly over it
	if distance >= self.parent:getRadius() then
		self.x = self.parent:getX() - (self.parent:getRadius() * math.cos(angle))
		self.y = self.parent:getY() - (self.parent:getRadius() * math.sin(angle))
	end
	
	
end

--==============================================================================
-- Draw
--==============================================================================
function RadarBlip:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("line", self.x, self.y, self.radius/self.scale)
end
