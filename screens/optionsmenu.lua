local optionsmenu = {}
optionsmenu.__index = optionsmenu

function optionsmenu.init()
    -- setup scope to make this an object
    local m = {}
    setmetatable(m, optionsmenu)

    -- sprites/textures for the menu
    m.background = love.graphics.newImage(config.optionsmenu.background)
    m.indicator = love.graphics.newImage(config.optionsmenu.indicator)
    m.dial = love.graphics.newImage(config.optionsmenu.dial)
    m.sizeindicator = love.graphics.newImage(config.optionsmenu.sizeindicator)

    -- index of current menu selection
    m.index = 1

    -- start angle for volume dial
    m.angle = (math.pi - math.pi/8) + math.pi/8 * config.sounds.volume * 10

    -- offset for dial and size slider drawing
    m.offset = {
        dial = 
        {
            x = m.dial:getWidth()/2,
            y = m.dial:getHeight()/2
        },
        size = (config.game.scale-1)/config.optionsmenu.sizeinc * config.optionsmenu.pixelinc
    }

    return m
end

function optionsmenu:update(dt)

end

function optionsmenu:draw()
    love.graphics.draw(self.background, 0, 0)
    love.graphics.draw(self.indicator, config.optionsmenu.menuoptions[self.index].x, config.optionsmenu.menuoptions[self.index].y)
    love.graphics.draw(self.dial, config.optionsmenu.dialpos.x, config.optionsmenu.dialpos.y, self.angle, 1, 1, self.offset.dial.x, self.offset.dial.y)
    love.graphics.draw(self.sizeindicator, config.optionsmenu.sizebarpos.x + self.offset.size, config.optionsmenu.sizebarpos.y)
end

function optionsmenu:keypressed(key)

    local cc = config.controls
    local ci = config.controlindex

    if key == cc[ci.kb][ci.down] then
        self.index = self.index + 1
        if self.index > #config.optionsmenu.menuoptions then
            self.index = 1
        end
    elseif key == cc[ci.kb][ci.up] then
        self.index = self.index - 1
        if self.index < 1 then
            self.index = #config.optionsmenu.menuoptions
        end
    elseif self.index == 1 and key == cc[ci.kb][ci.left] then
        -- window minus
        config.game.scale = config.game.scale - config.optionsmenu.sizeinc
        if config.game.scale < 1 then
            config.game.scale = 1
        end

        self.offset.size = (config.game.scale-1)/config.optionsmenu.sizeinc * config.optionsmenu.pixelinc

        resetVirtualCanvas()
        saveConfig()

    elseif self.index == 1 and key == cc[ci.kb][ci.right] then
        -- window plus
        config.game.scale = config.game.scale + config.optionsmenu.sizeinc
        if config.game.scale > 2 then
            config.game.scale = 2
        end

        self.offset.size = (config.game.scale-1)/config.optionsmenu.sizeinc * config.optionsmenu.pixelinc

        resetVirtualCanvas()
        saveConfig()

    elseif self.index == 2 and key == cc[ci.kb][ci.left] then
        -- volume down
        config.sounds.volume = config.sounds.volume - 0.1
        if config.sounds.volume < 0 then
            config.sounds.volume = 0
        end

        self.angle = (math.pi - math.pi/8) + math.pi/8 * config.sounds.volume * 10

        love.audio.setVolume(config.sounds.volume)
        saveConfig()

    elseif self.index == 2 and key == cc[ci.kb][ci.right] then
        -- volume up
        config.sounds.volume = config.sounds.volume + 0.1
        if config.sounds.volume > 1 then
            config.sounds.volume = 1
        end

        -- angle of dial sprite
        self.angle = (math.pi - math.pi/8) + math.pi/8 * config.sounds.volume*10

        love.audio.setVolume(config.sounds.volume)
        saveConfig()
        
    elseif key == cc[ci.kb][ci.ok] then
        if self.index == 3 then
            -- controls menu
            menu = "controls"
        elseif self.index == 4 then
            -- main menu
            menu = "main"
        end
    elseif key == cc[ci.kb][ci.menu] then
        -- main menu
        menu = "main"
    end
end

return optionsmenu