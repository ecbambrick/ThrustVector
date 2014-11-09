Thrust Vector: Maximum Turbo
================================================================================
A simple top-down arcade game. Requires LÖVE 8.0 to run (https://love2d.org/).

![screenshot](https://cloud.githubusercontent.com/assets/2266175/4837118/376005fc-5fd0-11e4-9e6d-378c20939776.png)

Controls
--------------------------------------------------------------------------------
* **left:** turn left
* **right:** turn right
* **up:** increase velocity
* **down:** decrease velocity
* Decreasing velocity will increase rotation speed

Gameplay
--------------------------------------------------------------------------------
Collect green orbs while avoiding missiles for as long as possible. Each green 
orb collected will recover your health. If you're hit by missiles too many
times, the game ends.

Health is displayed on your ship. If the ship is completely blue, you have full 
health, if half of the ship is blue, you have half health.

Radar surrounds the player and displays the direction of objects as small 
circles. As an object approaches the player, the circles will increase in size. 
Red objects are hostile and green objects are items.

Third Party Libraries and Resources:
--------------------------------------------------------------------------------
* [Hardon Collider](http://vrld.github.com/HardonCollider/ "Hardon Collider")
* [LÖVE](http://love2d.org/ "LÖVE")
* [Multiple Inheritance Classes](http://lua-users.org/wiki/MultipleInheritanceClasses "Multiple Inheritance Classes")
* [Viper Squadron Font](http://www.shyfoundry.com/ "Viper Squadron Font")
