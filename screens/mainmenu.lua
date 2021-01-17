local mainmenu = {}
mainmenu.__index = mainmenu

function mainmenu.init()
    -- setup scope to make this an object
    local m = {}
    setmetatable(m, mainmenu)

    -- sprites/textures for the menu
    m.background = love.graphics.newImage(config.mainmenu.background)
    m.indicator = love.graphics.newImage(config.mainmenu.indicator)

    -- index of current menu
    m.index = 1

    return m
end

function mainmenu:update(dt)

end

function mainmenu:draw()
    love.graphics.draw(self.background, 0, 0)
    love.graphics.draw(self.indicator, config.mainmenu.menuoptions[self.index].x1, config.mainmenu.menuoptions[self.index].y)
    love.graphics.draw(self.indicator, config.mainmenu.menuoptions[self.index].x2, config.mainmenu.menuoptions[self.index].y)
end

function mainmenu:keypressed(key)
    local cc = config.controls
    local ci = config.controlindex

    if key == cc[ci.kb][ci.down] then
        self.index = self.index + 1
        if self.index > #config.mainmenu.menuoptions then
            self.index = 1
        end
    elseif key == cc[ci.kb][ci.up] then
        self.index = self.index - 1
        if self.index < 1 then
            self.index = #config.mainmenu.menuoptions
        end
    elseif key == cc[ci.kb][ci.ok] then
        if self.index == 1 then
            -- new game
            game = true
        elseif self.index == 2 then
            -- options menu (and reset index)
            menu = "options"
            optionsmenu.index = 1
        elseif self.index == 3 then
            -- quit
            love.event.quit()
        end
    end
end

return mainmenu