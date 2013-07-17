GameOverScreen = {
	image1 = {
		img = love.graphics.newImage("res/gameover.png"),
		x = ( WINDOW_WIDTH - 315 ) / 2,
		y = 100,
	},
	image2 = {
		img = love.graphics.newImage("res/tryagain.png"),
		x = ( WINDOW_WIDTH - 370 ) / 2,
		y = WINDOW_HEIGHT - 100,
	},
	draw = function(self)
		love.graphics.draw(self.image1.img, self.image1.x, self.image1.y)
		love.graphics.draw(self.image2.img, self.image2.x, self.image2.y)
	end
}

TitleScreen = {
	timer = 1,
	maxTime = 1,
	display = true,
	titleImage = love.graphics.newImage("res/title.png"),
	enterImage = love.graphics.newImage("res/pressenter.png"),
	update = function(self, dt)
		self.timer = self.timer + dt
		if self.timer > self.maxTime then
			self.timer = 0
			display = not display
		end
		if love.keyboard.isDown("return") then
			scene = mainScene
			SCORE_DISPLAY = "score: 0\nhigh score: 0"
		end
	end,
	draw = function(self)
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(self.titleImage, 0, 0)
		if display then
			love.graphics.draw(self.enterImage, 287, 441)
		end
	end,
}