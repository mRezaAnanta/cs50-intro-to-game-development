--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class({ __includes = BaseState })

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24
local randSpawnTimer = 0
SCORE = 0
CURRENT_BIRD_POSITION = 0

function PlayState:init()
	self.bird = Bird()
	self.pipePairs = {}
	self.timer = 0
	-- self.score = 0
	-- self.randSpawnTimer = math.random(2, 10)

	-- initialize our last recorded Y value for a gap placement to base other gaps off of
	self.lastY = -PIPE_HEIGHT + math.random(80) + 20
	self.pause = false
end

function PlayState:update(dt)
	CURRENT_BIRD_POSITION = self.bird.y
	-- update timer for pipe spawning

	if love.keyboard.wasPressed("p") then
		-- CURRENT_BIRD_POSITION = self.bird.y
		-- gStateMachine:change("pause")
		-- self.bird.y = CURRENT_BIRD_POSITION
		-- love.graphics.setFont(flappyFont)
		-- love.graphics.print("Bird Y: " .. tostring(CURRENT_BIRD_POSITION), 8, 40)
		if scrolling == false then
			scrolling = true
		else
			scrolling = false
		end
	end

	if scrolling == true then
		self.pause = false
		self.timer = self.timer + dt

		-- TODO: make the timer into random number between 2 and 10
		-- spawn a new pipe pair every second and a half
		if self.timer > randSpawnTimer then
			-- if self.timer > 2 then
			-- modify the last Y coordinate we placed so pipe gaps aren't too far apart
			-- no higher than 10 pixels below the top edge of the screen,
			-- and no lower than a gap length (90 pixels) from the bottom
			local y = math.max(
				-PIPE_HEIGHT + 10,
				math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT)
			)
			self.lastY = y

			-- add a new pipe pair at the end of the screen at our new Y
			table.insert(self.pipePairs, PipePair(y))

			-- reset timer
			self.timer = 0
			randSpawnTimer = math.random(2, 4)
			GAP_HEIGHT = math.random(100, 140)
		end

		-- for every pair of pipes..
		for k, pair in pairs(self.pipePairs) do
			-- score a point if the pipe has gone past the bird to the left all the way
			-- be sure to ignore it if it's already been scored
			if not pair.scored then
				if pair.x + PIPE_WIDTH < self.bird.x then
					-- self.score = self.score + 1
					SCORE = SCORE + 1
					pair.scored = true
					sounds["score"]:play()
				end
			end

			-- update position of pair
			pair:update(dt)
		end

		-- we need this second loop, rather than deleting in the previous loop, because
		-- modifying the table in-place without explicit keys will result in skipping the
		-- next pipe, since all implicit keys (numerical indices) are automatically shifted
		-- down after a table removal
		for k, pair in pairs(self.pipePairs) do
			if pair.remove then
				table.remove(self.pipePairs, k)
			end
		end

		-- simple collision between bird and all pipes in pairs
		for k, pair in pairs(self.pipePairs) do
			for l, pipe in pairs(pair.pipes) do
				if self.bird:collides(pipe) then
					sounds["explosion"]:play()
					sounds["hurt"]:play()

					gStateMachine:change("score", {
						-- score = self.score,
						score = SCORE,
					})
				end
			end
		end

		-- update bird based on gravity and input
		self.bird:update(dt)

		-- reset if we get to the ground
		if self.bird.y > VIRTUAL_HEIGHT - 15 then
			sounds["explosion"]:play()
			sounds["hurt"]:play()

			gStateMachine:change("score", {
				-- score = self.score,
				score = SCORE,
			})
		end
	elseif self.pause == false then
		self.pause = true
	end
end

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	-- love.graphics.print("Score: " .. tostring(self.score), 8, 8)
	love.graphics.print("Score: " .. tostring(SCORE), 8, 8)
	-- love.graphics.print("Spawn Timer: " .. tostring(randSpawnTimer), 10, 10)
	love.graphics.print("Bird Y: " .. tostring(CURRENT_BIRD_POSITION), 8, 40)

	self.bird:render()

	if self.pause == true then
		love.graphics.setFont(flappyFont)
		love.graphics.print("Paused! Press P to play! ", 8, 8)
	end
	-- self.bird:render(self.x, self.y)
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
	-- if we're coming from death, restart scrolling
	self.bird.y = CURRENT_BIRD_POSITION
	scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
	-- stop scrolling for the death/score screen
	scrolling = false
end
