shooter_game
============
Simple LOVE2D game. Requires LOVE to run (https://love2d.org/)

Controls and Information
-------------------------------------------
* left:	turn left
* right:	turn right
* up:		increase speed
* down:	decrease speed (decreasing speed will increase rotation speed)

Health is displayed on your ship. If the ship is completely blue, you have full health, if half of 
the ship is blue, you have half health.

Radar surrounds the player and displays the direction of objects as small circles. As an object approaches the player,
the circles will increase in size. Red objects are hostile and green objects are items.

Collect green orbs (location is displayed on the radar that surrounds the player as green circles)
Avoid missiles (displayed on radar as red circles)

Green orbs will recover one health point, you have three health points in total

Third Party Libraries and Resources:
-------------------------------------------
* HardonCollider (http://vrld.github.com/HardonCollider/)
* Multiple Inheritance Classes (http://lua-users.org/wiki/MultipleInheritanceClasses)
* Viper Squadron Font (http://www.shyfoundry.com/)