require "lib.classlib"
class.Tail()

--==============================================================================
-- Constructor
--   interval = number of discrete points in the tail
--   limit = length of tail
--==============================================================================
function Tail:__init(parent, color, interval, limit)
	self.parent = parent
	self.length = length 
	self.interval = interval or 0.01
	self.limit = limit or 1
	self.color = color
	self.timer = 0
	self.path = {}
end

--==============================================================================
-- Update
--==============================================================================
function Tail:update(dt, x, y)
	self.timer = self.timer + dt
	
	-- push a new section of the tail onto the end
	if self.timer > self.interval then
		self.timer = 0
		table.insert(self.path, {x=x, y=y, timer=self.limit})
	end
	
	-- pop the first section of the tail
	for i,v in pairs(self.path) do
		v.timer = v.timer - dt
		if v.timer < 0 then table.remove(self.path, i) end
	end
end

--==============================================================================
-- Draw
--==============================================================================
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