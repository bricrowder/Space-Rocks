local controlsmenu = {}
controlsmenu.__index = controlsmenu

function controlsmenu.init()
    -- setup scope to make this an object
    local m = {}
    setmetatable(m, controlsmenu)

    -- sprites/textures for the menu
    m.background = love.graphics.newImage(config.controlsmenu.background)
    m.indicator = love.graphics.newImage(config.controlsmenu.indicator)

    -- index of current menu
    m.index = 1

    return m
end

function controlsmenu:update(dt)

end

function controlsmenu:draw()
    love.graphics.draw(self.background, 0, 0)
    love.graphics.draw(self.indicator, config.controlsmenu.menuoptions[self.index].x1, config.controlsmenu.menuoptions[self.index].y)
    love.graphics.draw(self.indicator, config.controlsmenu.menuoptions[self.index].x2, config.controlsmenu.menuoptions[self.index].y)
end

function controlsmenu:keypressed(key)
    if key == "down" then
        -- uncomment when more than one option
        -- self.index = self.index + 1
        -- if self.index > #config.controlsmenu.menuoptions then
        --     self.index = 1
        -- end
    elseif key == "up" then
        -- uncomment when more than one option
        -- self.index = self.index - 1
        -- if self.index < 1 then
        --     self.index = #config.controlsmenu.menuoptions
        -- end

    elseif key == "escape" then
        -- return to game
        menu = "options"
    elseif key == "space" then
        if self.index == 1 then
            -- return to main menu
            menu = "options"
        end
    end
end

return controlsmenu