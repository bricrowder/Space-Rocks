local pausemenu = {}
pausemenu.__index = pausemenu

function pausemenu.init()
    -- setup scope to make this an object
    local m = {}
    setmetatable(m, pausemenu)

    -- sprites/textures for the menu
    m.background = love.graphics.newImage(config.pausemenu.background)
    m.indicator = love.graphics.newImage(config.pausemenu.indicator)

    -- index of current menu
    m.index = 1

    return m
end

function pausemenu:update(dt)

end

function pausemenu:draw()
    love.graphics.draw(self.background, 0, 0)
    love.graphics.draw(self.indicator, config.pausemenu.menuoptions[self.index].x1, config.pausemenu.menuoptions[self.index].y)
    love.graphics.draw(self.indicator, config.pausemenu.menuoptions[self.index].x2, config.pausemenu.menuoptions[self.index].y)
end

function pausemenu:keypressed(key)
    local cc = config.controls
    local ci = config.controlindex

    if key == cc[ci.kb][ci.down] then
        self.index = self.index + 1
        if self.index > #config.pausemenu.menuoptions then
            self.index = 1
        end
    elseif key == cc[ci.kb][ci.up]then
        self.index = self.index - 1
        if self.index < 1 then
            self.index = #config.pausemenu.menuoptions
        end
    elseif key == cc[ci.kb][ci.menu] then
        -- return to game
        paused = false
    elseif key == cc[ci.kb][ci.ok] then
        if self.index == 1 then
            -- return to game
            paused = false
        elseif self.index == 2 then
            -- need 
            menu = "options"
        elseif self.index == 3 then
            -- quit - main menu, reset game
            game = false
            paused = false
            menu = "main"
        end
    end
end

return pausemenu