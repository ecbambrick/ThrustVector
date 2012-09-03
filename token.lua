require "lib.classlib"

class.Tail()

function Tail:__init(parent, color, interval, limit)
	self.parent = parent
	self.length = length 
	self.interval = interval or 0.01
	self.limit = limit or 1
	self.color = color
	self.timer = 0
	self.path = {}
end

function Tail:update(dt, x, y)
	self.timer = self.timer + dt

	if self.timer > self.interval then
		self.timer = 0
		table.insert(self.path, {x=x, y=y, timer=self.limit})
	end
	
	for i,v in pairs(self.path) do
		v.timer = v.timer - dt
		if v.timer < 0 then table.remove(self.path, i) end
	end
	
end

function Tail:draw()

	if #self.path < 2 then return end

	love.graphics.setColor(self.color)
	local prev = {}
	for i,v in pairs(self.path) do
		if i > 1 then
			love.graphics.line(prev.x, prev.y, v.x, v.y)
		end
		prev = {x=v.x, y=v.y}
	end
	love.graphics.line(prev.x, prev.y, self.parent:getTailPosition())
end

--------------------------------------------------------------------------------

class.Radar()

function Radar:__init(radius, color)
	self.x = 0
	self.y = 0
	self.radius = radius or 16
	self.color = color or COLOR_TEAL
	self.blips = {}
end

function Radar:update(dt, x, y)
	self.x = x
	self.y = y
	self:updateBlips(dt)
end

function Radar:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("line", self.x, self.y, self.radius)
	self:drawBlips()
end

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

function Radar:getX()		return self.x		end
function Radar:getY()		return self.y		end
function Radar:getRadius()	return self.radius	end

--------------------------------------------------------------------------------

class.RadarBlip()

-- parent = the radar this blip is attached to
-- object = the object this blip is tracking (ie - a missile)
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

function RadarBlip:update(dt)

	self.x = self.object:getX()
	self.y = self.object:getY()
	self.scale = math.sqrt( (self.x - self.parent:getX())^2 + (self.y - self.parent:getY())^2 ) / 80
	if self.radius/self.scale < 2 then self.scale = self.radius/2 end
	if self.scale < 1 then self.scale = 1 end
	
	local distance = math.sqrt(
		(self.x - self.parent:getX())^2
	  + (self.y - self.parent:getY())^2
	)
	local angle = math.atan2(
			self.parent:getY() - self.y, self.parent:getX() -  self.x
		)
		
	-- if the parent is within the radar radius, then draw directly over it
	if distance >= self.parent:getRadius() then
		self.x = self.parent:getX() - (self.parent:getRadius() * math.cos(angle))
		self.y = self.parent:getY() - (self.parent:getRadius() * math.sin(angle))
	end
	
	
end

function RadarBlip:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("line", self.x, self.y, self.radius/self.scale)
end

function RadarBlip:clean()
	self.parent:removeBlip(self)
end
