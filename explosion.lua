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

class.Explosion()

local explosionParticle = love.graphics.newImage("res/explosion.png");

function Explosion:__init(x, y, angle)
	self.timer = 0
	scene:addObject(self)
	self.p = love.graphics.newParticleSystem(explosionParticle, 1000)
	self.p:setEmissionRate(100)
	self.p:setSpeed(100, 1000)
	self.p:setSizes(1, 1)
	self.p:setColors(255, 255, 255, 255, 255, 50, 50, 0)
	self.p:setPosition(400, 300)
	self.p:setLifetime(0.1)
	self.p:setParticleLife(0.3)
	self.p:setDirection(0)
	self.p:setSpread(math.pi/2)
	self.p:setPosition(x,y)
	self.p:setDirection(angle-math.pi)
end

function Explosion:update(dt)
	self.timer = self.timer + dt
	self.p:update(dt)
	if self.timer > 1 then
		self.p:stop()
		scene:removeObject(self)
	end
end

function Explosion:draw()
	love.graphics.draw(self.p, 0, 0)
end

--------------------------------------------------------------------------------

class.ExplosionChunk()

function ExplosionChunk:__init(x, y)
	
end

function ExplosionChunk:update(dt)
	
end

function ExplosionChunk:draw()
	
end