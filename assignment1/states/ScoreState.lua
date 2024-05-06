--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class({ __includes = BaseState })

GOLD_MEDAL = love.graphics.newImage("1st medal pixel.png")
SILVER_MEDAL = love.graphics.newImage("2nd medal pixel.png")
BRONZE_MEDAL = love.graphics.newImage("3rd medal pixel.png")
--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]

function ScoreState:init()
	-- self.bird = Bird()
end

-- TODO: how to display an image when you enter the scorestate
-- TODO: use 3 different image for each high scores, and have minimum score needed for each one
function ScoreState:enter(params)
	self.score = params.score
end

function ScoreState:update(dt)
	-- go back to play if enter is pressed
	-- CURRENT_BIRD_POSITION = VIRTUAL_HEIGHT / 2 - 8
	-- CURRENT_BIRD_POSITION = self.bird.y
	CURRENT_BIRD_POSITION = Bird().y
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		gStateMachine:change("countdown")
	end
end

function ScoreState:render()
	-- simply render the score to the middle of the screen
	love.graphics.setFont(flappyFont)
	love.graphics.printf("Oof! You lost!", 0, 64, VIRTUAL_WIDTH, "center")

	love.graphics.setFont(mediumFont)
	if self.score >= 5 then
		love.graphics.draw(GOLD_MEDAL, VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT / 2 + 30)
		love.graphics.printf("Score: " .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, "center")
	elseif self.score >= 3 then
		love.graphics.printf("Score: " .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, "center")
		love.graphics.draw(SILVER_MEDAL, VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT / 2 + 30)
	elseif self.score >= 1 then
		love.graphics.printf("Score: " .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, "center")
		love.graphics.draw(BRONZE_MEDAL, VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT / 2 + 30)
	else
		love.graphics.printf("Score: " .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, "center")
	end

	love.graphics.printf("Press Enter to Play Again!", 0, 160, VIRTUAL_WIDTH, "center")
end
