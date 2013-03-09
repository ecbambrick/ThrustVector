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

class.Scenario()

--==============================================================================
-- Constructor
--  startX and startY are the starting coordinates of the player
--	numSpawners is the number of missile spawners to generate
--	1/missileChance*dt is the chance a missile will spawn
--==============================================================================
function Scenario:__init(width, height)
	
	-- Initialize properties
	self.width = width or WINDOW_WIDTH
	self.height = height or WINDOW_HEIGHT
	
	-- The list of game objects (ie - player, spawner, missile, etc.)
	self.objects = {}
	
end

--==============================================================================
-- Update/draw all objects in the scenario
--==============================================================================
function Scenario:update(dt)
	for i,v in pairs(self.objects) do v:update(dt) end
end

function Scenario:draw(dt)
	for i,v in pairs(self.objects) do v:draw() end
end

--==============================================================================
-- Modify the list of objects
--==============================================================================
function Scenario:addObject(object)
	table.insert(self.objects, object)
	return
end

function Scenario:removeObject(object)
	for i,v in ipairs(self.objects) do
		if v == object then
			table.remove(self.objects, i)
			object = nil
			return
		end
	end
end

--==============================================================================
-- Setters and Getters
--==============================================================================
function Scenario:getWidth() return self.width end
function Scenario:getHeight() return self.height end
function Scenario:getObjects() return self.objects end