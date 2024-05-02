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

-- function PauseState:init() end
function PauseState:enter()
	sounds["score"]:play()
	sounds["music"]:setLooping(true)
	sounds["music"]:play()

	scrolling = false
end
-- function PauseState:exit() end

-- TODO: change the countdown so that if we're in the pause state all the scene (score, bird and pipe placement is still the same)
function PauseState:update(dt)
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		gStateMachine:change("countdown")
	end
end

-- TODO: render the pause scene with all of the pipe and bird is visibly in place
function PauseState:render() end
