local game = {}
game.__index = game

function game.init()
    -- setup scope to make this an object
    local g = {}
    setmetatable(g, game)

    g.x = nativeCanvas:getWidth()/2
    g.y = nativeCanvas:getHeight()/2

    return g
end

function game:update(dt)

end

function game:draw()    
    love.graphics.print("Press Escape to Pause\nq to end game", self.x - 40, self.y)
end

function game:keypressed(key)
    if key == "q" then
        endgame = true
    end
end

function game:gamepadpressed(button)
end

return game