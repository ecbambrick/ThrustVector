--[[ TO DO ---------------------------------------------------------------------

	health
		player invincible on hit temporarily

	goal
		goal randomly appears 1000 pixels infront ofb player
		create two at once, one being a powerup thing, 3 at 25 intervals
		goal animates slightly (pulsates)
		
	
--------------------------------------------------------------------------------

	main menu
		how to play
		high scores
		settings
			button config
			difficulty
			
	polish
		music, sound effects
		stars in background
		balance
		
	bugs
		missile tail draws from 0,0 sometimes
		sometimes hardoncollider crashes
		
	name
		bahlraj
		
---- CONCEPTS ------------------------------------------------------------------

	COMBOS: each power last 10 seconds
			getting new power resets timers for current power ups
			as accumlate multiple, score increases a tonne
			gets more difficult or something

	decide between life an power up
	after 10	power ups
	every 25	something random (good or bad, worth taking)
	
	Power ups (last 10 seconds)
		spread gun
		homing laser (like ZoE)
		laser (forward)
		lasers (to the sides)
		speed boost
		torque boost
		rotating shield
		increased invincibility after hit
		shields (2 uses)
		
	Random (last 1 minute)
		missles turn into something harmless
		missiles turn into gunships
		boss appears (kill for points)
		some kind of summon thing
		
		go overpowered lasers everywhere super speed
		get a gun, turn into a stationary turret thing
		
------------------------------------------------------------------------------]]

require "camera"
require "goal"
require "player"
require "scenario"
require "spawner"

COLOR_TEAL		= { 165, 234, 241, 255 }
COLOR_ORANGE	= { 255, 100, 100, 255 }
COLOR_RED		= { 255, 0,   0,   255 }
COLOR_WHITE		= { 255, 255, 255, 255 }
COLOR_LIME		= { 181, 230, 29,  255 }

WINDOW_WIDTH	= love.graphics.getWidth()
WINDOW_HEIGHT	= love.graphics.getHeight()
DEBUGMSG		= "tesst"

local fpsCount = 0
local fpsTime = 0

--==============================================================================
-- Load game
--==============================================================================
function love.load()

	-- Load collision detection
	HC = require "lib/HardonCollider"
	collider = HC(100, onCollision)

	-- load scene
	local size = 50000
	scene = Scenario(size, size)
	
	-- Load game objects
	player = Player(400,300)
	spawner = Spawner(1000, 15)
	goal = Goal(player, 500, 500)
	scene:addObject(player)
	scene:addObject(spawner)
	scene:addObject(goal)
	
	-- Load camera
	camera = Camera(400, 300, 1, 0, player, "follow")
	
	bg = love.graphics.newImage("res/grid.png")
	
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
	--updateFPS(dt)
	scene:update(dt)
	collider:update(dt)
	camera:update(dt)
	
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
	love.graphics.print(DEBUGMSG, 10, 10)
	
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
		a:decrementHealth()
		b:explode(a:getX(), a:getY(), b:getAngle())
		camera:shake()
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

-- Update FPS counter
function updateFPS(dt)
	fpsCount = fpsCount+1
	fpsTime = fpsTime + dt
	if fpsTime >= 1 then
		DEBUGMSG = fpsCount
		fpsTime = 0
		fpsCount = 0
	end
end

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
			love.graphics.draw(image, i, j)
		end
	end
end
