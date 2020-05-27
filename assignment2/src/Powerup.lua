--[[

    -- Ball Class --

    Author: Jason Carlson
    jtcarlso@asu.edu

    Represents a powerup that falls until the player hits it or it falls out of the map. This spawns
    more balls.
]]

Powerup = Class{}

function Powerup:init()
    -- simple positional and dimensional variables
    self.width = 15
    self.height = 15

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 10
    self.dx = 0

    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    --timer for when the powerup should reset 
    self.resetTimer = 0

    self.inPlay = true
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    middle of the screen, falling movement.
]]
function Powerup:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 10
    self.resetTimer = 0
    self.inPlay = true
end

function Powerup:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.resetTimer = self.resetTimer + dt

    -- Powerup stops falling once it is off the screen
    if self.y >= VIRTUAL_HEIGHT then
        self.x = 0
        self.dy = 0
        self.inPlay = false
    end

    -- reset the powerup to the top of the screen if it has been
    -- more than 20 seconds
    if self.resetTimer > 30 then
        self:reset()
    end

end

function Powerup:render()
    -- gTexture is our global texture for all blocks
    -- the last ball in gFrames['powerup'] is the key ball (which is at position 9 - indexing from 0)
    -- by ball, I mean the things shaped like a ball in the last row. These are different from the 
    -- textures used in ball.lua
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][9],
            self.x, self.y)
    end
end