COLOR_TEAL		= { 165, 234, 241, 255 }
COLOR_ORANGE	= { 255, 100, 100, 255 }
COLOR_RED		= { 255, 0,   165, 255 }
COLOR_WHITE		= { 255, 255, 255, 255 }
COLOR_LIME		= { 181, 230, 29,  255 }

WINDOW_WIDTH	= love.graphics.getWidth()
WINDOW_HEIGHT	= love.graphics.getHeight()
SCORE_DISPLAY	= ""
TIME_STEP		= 1/100
TIME_DELTA		= 0

require "camera"
require "goal"
require "player"
require "scenario"
require "spawner"
require "screens"

--==============================================================================
-- Load game
--==============================================================================
function love.load()

	-- Load collision detection
	HC = require "lib/HardonCollider"
	collider = HC(100, onCollision)

	-- load scenes
	local size = 50000
	mainScene = Scenario(size, size)
	titleScene = Scenario(0,0)
	scene = titleScene
	
	-- Load game objects
	player = Player(400,300)
	spawner = Spawner(1000, 15)
	goal = Goal(player, 500, 500)
	mainScene:addObject(player)
	mainScene:addObject(spawner)
	mainScene:addObject(goal)
	titleScene:addObject(TitleScreen)
	bg = love.graphics.newImage("res/grid.png")
	
	-- Load camera
	camera = Camera(400, 300, 1, 0, player, "follow")
	
	-- Load font
	local font = love.graphics.newImageFont("res/font.png",
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
		"123456789.,!?-+/():;%&`'*#=[]\"")
	love.graphics.setFont(font)
	
end

--==============================================================================
-- Update logic
--==============================================================================
function love.update(dt)
	TIME_DELTA = TIME_DELTA + dt
	while TIME_DELTA > TIME_STEP do
		scene:update(TIME_STEP)
		collider:update(TIME_STEP)
		camera:update(TIME_STEP)
		TIME_DELTA = TIME_DELTA - TIME_STEP
	end
end

--==============================================================================
-- Draw assets
--==============================================================================
function love.draw()

	-- Draw game scene
	camera:set()
		drawRepeatingBG(bg)
		scene:draw()
	camera:unset()
	
	-- Draw interface
	love.graphics.setColor(255,255,255,255)
	love.graphics.print(SCORE_DISPLAY, 10, 10)
	if not player.active then
		GameOverScreen:draw()
	end
	
end

--==============================================================================
-- Collision detection
--==============================================================================
function onCollision(dt, shape_a, shape_b)
	
	local a = shape_a.parent
	local b = shape_b.parent

	if classname(a) == "Player" and classname(b) == "Goal" then
		a:incrementHealth()
		b:capture()
	end
	
	if classname(a) == "Player" and classname(b) == "Missile" then
		if b.active then
			a:decrementHealth()
			b:explode(a:getX(), a:getY(), b:getAngle())
			camera:shake()
		end
	end
	
	if classname(a) == "Bullet" and classname(b) == "Missile" then
		a:die()
		b:explode(b:getX(), b:getY(), b:getAngle())
	end
	
	if classname(a) == "Laser" and classname(b) == "Missile" and a.shooting then
		b:explode(b:getX(), b:getY(), b:getAngle())
	end
	

end

--==============================================================================
-- Helper functions
--==============================================================================

-- Create a list of values that can be checked with set["val"]
function set (list)
	local set = {}
	for _, l in ipairs(list) do set[l] = false end
	return set
end

-- Return the value with the highest magnitude (ignore sign)
function absMax(a,b)
	if math.abs(a) > math.abs(b) then return a
	else return b end
end

-- Return the value with the lowest magnitude (ignore sign)
function absMin(a,b)
	if math.abs(a) > math.abs(b) then return a
	else return b end
end

-- Draw an image repeating both x and y on the screen
-- only draws within the camera's line of sight
function drawRepeatingBG(image)
	local x1 = camera.x - (camera.x % image:getWidth())
	local y1 = camera.y - (camera.y % image:getHeight())
	local x2 = x1 + WINDOW_WIDTH + image:getWidth()
	local y2 = y1 + WINDOW_HEIGHT + image:getWidth()
	
	for i = x1, x2, image:getWidth() do
		for j = y1, y2, image:getHeight() do 
			love.graphics.setColor({11, 33, 33, 255})
			love.graphics.draw(image, i, j)
		end
	end
end
