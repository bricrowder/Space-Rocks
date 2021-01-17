local controlsmenu = {}
controlsmenu.__index = controlsmenu

function controlsmenu.init()
    -- setup scope to make this an object
    local m = {}
    setmetatable(m, controlsmenu)

    -- sprites/textures for the menu
    m.background = love.graphics.newImage(config.controlsmenu.background)
    m.indicator = love.graphics.newImage(config.controlsmenu.indicator)

    -- index of action
    m.index = 1
    -- index of device
    m.colindex = 2

    -- if the control is being edited / looking for input
    m.edit = false

    return m
end

function controlsmenu:update(dt)

end

function controlsmenu:draw()
    local cm = config.controlsmenu
    local cc = config.controls

    -- draw background
    love.graphics.draw(self.background, 0, 0)

    -- draw row/column highlights
    if self.index < cm.rows.count + 1 then
        -- calc row position
        local y = cm.rows.y + (self.index - 1) * cm.rows.h
        love.graphics.setColor(cm.colours.row)
        love.graphics.rectangle("fill", cm.panel.x, y, cm.panel.w, cm.rows.h)

        if self.edit then
            love.graphics.setColor(cm.colours.edit)
        else            
            love.graphics.setColor(cm.colours.cell)
        end

        love.graphics.rectangle("fill", cm.columns[self.colindex].x, y, cm.columns[self.colindex].w, cm.rows.h)        
    else
        love.graphics.draw(self.indicator, cm.menuoptions[self.index - cm.rows.count].x1, cm.menuoptions[self.index - cm.rows.count].y)
        love.graphics.draw(self.indicator, cm.menuoptions[self.index - cm.rows.count].x2, cm.menuoptions[self.index - cm.rows.count].y)
    end

    -- draw the key labels
    love.graphics.setColor(cm.colours.text)

    -- draw the controls
    for i=1, #cc do
        for j=1, #cc[1] do
            if cc[i][j] then
                love.graphics.print(cc[i][j], cm.columns[i].x, cm.rows.y + cm.rows.h * (j-1))
            end
        end
    end

    love.graphics.setColor(1,1,1,1)

    -- draw rectangle around controls
    love.graphics.rectangle("line", cm.panel.x, cm.panel.y, cm.panel.w, cm.panel.h)
end

function controlsmenu:keypressed(key)
    -- references to reduce typing!
    local cm = config.controlsmenu
    local cc = config.controls
    local ci = config.controlindex

    -- in edit mode or not
    if self.edit then
        -- set the key and get out of edit mode
        cc[self.colindex][self.index] = key
        self.edit = false
    else
        -- do the key action
        if key == cc[ci.kb][ci.down] then
            self.index = self.index + 1
            if self.index > cm.rows.count + #cm.menuoptions then
                self.index = 1
            end
        elseif key == cc[ci.kb][ci.up] then
            self.index = self.index - 1
            if self.index < 1 then
                self.index = cm.rows.count + #cm.menuoptions
            end
        elseif key == cc[ci.kb][ci.left] then
            -- uncomment when more than one option
            self.colindex = self.colindex - 1
            if self.colindex < 2 then
                self.colindex = #cm.columns
            end
        elseif key == cc[ci.kb][ci.right] then
            -- uncomment when more than one option
            self.colindex = self.colindex + 1
            if self.colindex > #cm.columns then
                self.colindex = 2
            end

        elseif key == cc[ci.kb][ci.menu] then
            -- return to game
            menu = "options"
        elseif key == cc[ci.kb][ci.ok] then
            if self.index == cm.rows.count + #cm.menuoptions then
                -- return to main menu
                menu = "options"
            elseif self.index <= cm.rows.count then
                -- process row/col change
                if not self.edit then
                    self.edit = true                
                end
            end
        end
    end
end

return controlsmenu