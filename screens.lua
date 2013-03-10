GameOverScreen = {
	image1 = {
		img = love.graphics.newImage("res/gameover.png"),
		x = ( WINDOW_WIDTH - 315 ) / 2,
		y = 100,
	},
	image2 = {
		img = love.graphics.newImage("res/tryagain.png"),
		x = ( WINDOW_WIDTH - 389 ) / 2,
		y = WINDOW_HEIGHT - 100,
	},
	draw = function(self)
		love.graphics.draw(self.image1.img, self.image1.x, self.image1.y)
		love.graphics.draw(self.image2.img, self.image2.x, self.image2.y)
	end
}