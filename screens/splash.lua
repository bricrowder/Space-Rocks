local splash = {}
splash.__index = splash

function splash.init()
    -- setup scope to make this an object
    local m = {}
    setmetatable(m, splash)

    -- sprites/textures for the menu
    m.background = love.graphics.newImage(config.splash.background)
    m.timer = 0

    return m
end

function splash:update(dt)
    self.timer = self.timer + dt
    if self.timer >= config.splash.duration then
        menu = "main"
    end
end

function splash:draw()
    love.graphics.draw(self.background, 0, 0)
end

function splash:keypressed(key)
    -- force the timer to the end and let the update handle it
    self.timer = config.splash.duration
end

return splash