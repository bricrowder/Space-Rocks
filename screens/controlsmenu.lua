local controlsmenu = {}
controlsmenu.__index = controlsmenu

function controlsmenu.init()
    -- setup scope to make this an object
    local m = {}
    setmetatable(m, controlsmenu)

    -- sprites/textures for the menu
    m.background = love.graphics.newImage(config.controlsmenu.background)
    m.indicator = love.graphics.newImage(config.controlsmenu.indicator)

    -- index of current menu and column for this specific menu
    m.index = 1
    m.colindex = 2

    return m
end

function controlsmenu:update(dt)

end

function controlsmenu:draw()
    love.graphics.draw(self.background, 0, 0)
    local c = config.controlsmenu

    if self.index < config.controlsmenu.rows.count + 1 then
        local x = c.panel.x
        local y = c.rows.y + (self.index - 1) * c.rows.h
        love.graphics.setColor(0.1,0.1,0.1,0.25)
        love.graphics.rectangle("fill", x, y, c.panel.w, c.rows.h)

        love.graphics.setColor(0,0.1,0.1,0.25)
        local colx = config.controlsmenu.columns[self.colindex].x
        local colw = config.controlsmenu.columns[self.colindex].w
        love.graphics.rectangle("fill", colx, y, colw, c.rows.h)
        love.graphics.setColor(1,1,1,1)

    else
        love.graphics.draw(self.indicator, c.menuoptions[self.index - c.rows.count].x1, c.menuoptions[self.index - c.rows.count].y)
        love.graphics.draw(self.indicator, c.menuoptions[self.index - c.rows.count].x2, c.menuoptions[self.index - c.rows.count].y)
    end

    -- draw the key labels
    love.graphics.setColor(0,0,0,1)
    love.graphics.print("Up", c.columns[1].x, c.rows.y)
    love.graphics.print("Down", c.columns[1].x, c.rows.y + c.rows.h * 1)
    love.graphics.print("Left", c.columns[1].x, c.rows.y + c.rows.h * 2)
    love.graphics.print("Right", c.columns[1].x, c.rows.y + c.rows.h * 3)
    love.graphics.print("Jump", c.columns[1].x, c.rows.y + c.rows.h * 4)
    love.graphics.print("Menu/Back", c.columns[1].x, c.rows.y + c.rows.h * 5)
    love.graphics.print("Ok", c.columns[1].x, c.rows.y + c.rows.h * 6)

    -- keyboard
    love.graphics.print(config.controls.kb.up, c.columns[2].x, c.rows.y)
    love.graphics.print(config.controls.kb.down, c.columns[2].x, c.rows.y + c.rows.h * 1)
    love.graphics.print(config.controls.kb.left, c.columns[2].x, c.rows.y + c.rows.h * 2)
    love.graphics.print(config.controls.kb.right, c.columns[2].x, c.rows.y + c.rows.h * 3)
    love.graphics.print(config.controls.kb.jump, c.columns[2].x, c.rows.y + c.rows.h * 4)
    love.graphics.print(config.controls.kb.menu, c.columns[2].x, c.rows.y + c.rows.h * 5)
    love.graphics.print(config.controls.kb.ok, c.columns[2].x, c.rows.y + c.rows.h * 6)
    
    -- mouse
    -- love.graphics.print(config.controls.kb.up, c.columns[3].x, c.rows.y)
    -- love.graphics.print(config.controls.kb.down, c.columns[3].x, c.rows.y + c.rows.h * 1)
    -- love.graphics.print(config.controls.kb.left, c.columns[3].x, c.rows.y + c.rows.h * 2)
    -- love.graphics.print(config.controls.kb.right, c.columns[3].x, c.rows.y + c.rows.h * 3)
    -- love.graphics.print(config.controls.kb.jump, c.columns[3].x, c.rows.y + c.rows.h * 4)
    -- love.graphics.print(config.controls.kb.menu, c.columns[3].x, c.rows.y + c.rows.h * 5)
    love.graphics.print(config.controls.mouse.ok, c.columns[3].x, c.rows.y + c.rows.h * 6)

    -- gamepads
    for i, v in ipairs(config.controls.gamepad) do
        love.graphics.print(v.up, c.columns[3+i].x, c.rows.y)
        love.graphics.print(v.down, c.columns[3+i].x, c.rows.y + c.rows.h * 1)
        love.graphics.print(v.left, c.columns[3+i].x, c.rows.y + c.rows.h * 2)
        love.graphics.print(v.right, c.columns[3+i].x, c.rows.y + c.rows.h * 3)
        love.graphics.print(v.jump, c.columns[3+i].x, c.rows.y + c.rows.h * 4)
        love.graphics.print(v.menu, c.columns[3+i].x, c.rows.y + c.rows.h * 5)
        love.graphics.print(v.ok, c.columns[3+i].x, c.rows.y + c.rows.h * 6)    
    end


    love.graphics.setColor(1,1,1,1)

    love.graphics.rectangle("line", c.panel.x, c.panel.y, c.panel.w, c.panel.h)
end

function controlsmenu:keypressed(key)
    if key == config.controls.kb.down then
        self.index = self.index + 1
        if self.index > config.controlsmenu.rows.count + #config.controlsmenu.menuoptions then
            self.index = 1
        end
    elseif key == config.controls.kb.up then
        self.index = self.index - 1
        if self.index < 1 then
            self.index = config.controlsmenu.rows.count + #config.controlsmenu.menuoptions
        end
    elseif key == config.controls.kb.left then
        -- uncomment when more than one option
        self.colindex = self.colindex - 1
        if self.colindex < 2 then
            self.colindex = #config.controlsmenu.columns
        end
    elseif key == config.controls.kb.right then
        -- uncomment when more than one option
        self.colindex = self.colindex + 1
        if self.colindex > #config.controlsmenu.columns then
            self.colindex = 2
        end

    elseif key == config.controls.kb.menu then
        -- return to game
        menu = "options"
    elseif key == config.controls.kb.ok then
        if self.index == config.controlsmenu.rows.count + #config.controlsmenu.menuoptions then
            -- return to main menu
            menu = "options"
        elseif self.index <= config.controlsmenu.rows.count then
            -- process row/col change
        end
    end
end

return controlsmenu