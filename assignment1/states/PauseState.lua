--[[
    PauseState Class

    Used as the base class for all of our states, so we don't have to
    define empty methods in each of them. StateMachine requires each
    State have a set of four "interface" methods that it can reliably call,
    so by inheriting from this base state, our State classes will all have
    at least empty versions of these methods even if we don't define them
    ourselves in the actual classes.
]]

PauseState = Class({ __includes = BaseState })

PAUSE = true

function PauseState:init()
	self.bird = Bird()
end

function PauseState:enter()
	sounds["score"]:play()
	sounds["music"]:setLooping(true)
	sounds["music"]:play()
end

function PauseState:exit()
	-- self.bird:update(dt)
end

-- TODO: change the countdown so that if we're in the pause state all the scene (score, bird and pipe placement is still the same)
function PauseState:update(dt)
	-- self.bird:update(dt)
	self.bird.y = CURRENT_BIRD_POSITION
	GRAVITY = 0
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		gStateMachine:change("countdown")
	end
end

-- TODO: render the pause scene with all of the pipe and bird is visibly in place
function PauseState:render()
	-- self.bird:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf("You Just ", 0, 64, VIRTUAL_WIDTH, "center")
	love.graphics.printf("Score: " .. tostring(SCORE), 0, 100, VIRTUAL_WIDTH, "center")
	love.graphics.printf("Press Enter to Play Again!", 0, 160, VIRTUAL_WIDTH, "center")
	love.graphics.printf("Bir Position: " .. tostring(CURRENT_BIRD_POSITION), 0, 200, VIRTUAL_WIDTH, "center")
end
