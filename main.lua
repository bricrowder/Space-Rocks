-- load json code modules
json = require ("external/dkjson")

-- load the configuration
config = json.opendecode("config.json")

-- the two main drawing canvases
nativeCanvas = love.graphics.newCanvas(config.game.width, config.game.height)
virtualCanvas = love.graphics.newCanvas(config.game.width * config.game.scale, config.game.height * config.game.scale)

-- load the menus/screens
mainmenu = require ("screens/mainmenu").init()
pausemenu = require ("screens/pausemenu").init()
optionsmenu = require ("screens/optionsmenu").init()
controlsmenu = require ("screens/controlsmenu").init()
splash = require ("screens/splash").init()

-- initialize global game state variables
game = false        -- if game is playing or not, it is the menu otherwise really...
menu = "splash"     -- the non-game menu you are on
paused = false      -- if the game is paused or not
endgame = false     -- if the game has ended

-- debug flag
debugstats = true

-- debug font
debugfont = love.graphics.newFont(12)

-- Audio files
menubip = love.audio.newSource(config.sounds.menubip, "static")


--[[
    LOAD ALL OTHER GLOBAL VARIABLES AND MODULES HERE
]]

function love.load()
    -- set the resolution from the configuration
    love.window.setMode(virtualCanvas:getWidth(), virtualCanvas:getHeight())

    -- setup the scaling drawing mode
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- set the volume
    love.audio.setVolume(config.sounds.volume)
end

function love.update(dt)
    if game then
        -- game code regardless of pausing

        if endgame then

        elseif not paused then
            -- game code

        else
            -- if game is paused
            if menu == "options" then
                optionsmenu:update(dt)
            elseif menu == "controls" then
                controlsmenu:update(dt)
            else
                pausemenu:update(dt)
            end
        end
    else
        -- menu code
        if menu == "main" then
            mainmenu:update(dt)
        elseif menu == "options" then
            optionsmenu:update(dt)
        elseif menu == "controls" then
            controlsmenu:update(dt)
        elseif menu == "splash" then
            splash:update(dt)
        end
    end

    -- reset the gamepad flag
    gamepad = false
end

function love.draw()
    -- draw everything at native
    love.graphics.setCanvas(nativeCanvas)
    love.graphics.clear()

    if game then
        -- game code regardless of pausing

        if endgame then
            -- if the game has ended (but not back in menu yet)
            love.graphics.print("Press any key to return to the main menu", nativeCanvas:getWidth()/2 - 40, nativeCanvas:getHeight()/2)
        elseif not paused then
            -- game code
            love.graphics.print("Press Escape to Pause\nq to end game", nativeCanvas:getWidth()/2 - 40, nativeCanvas:getHeight()/2)
        else
            -- if game is paused
            if menu == "options" then
                optionsmenu:draw()
            elseif menu == "controls" then
                controlsmenu:draw()
            else
                pausemenu:draw()
            end
        end
    else
        -- menu code
        if menu == "main" then
            mainmenu:draw()
        elseif menu == "options" then
            optionsmenu:draw()
        elseif menu == "controls" then
            controlsmenu:draw()
        elseif menu == "splash" then
            splash:draw()            
        end
    end

    -- draw the native canvas to the virtual canvas (using the scale)
    love.graphics.setCanvas(virtualCanvas)
    love.graphics.clear()

    love.graphics.draw(nativeCanvas, 0, 0, 0, config.game.scale, config.game.scale)

    -- apply anything else to the virtual canvas (such as UI or shaders)

    -- set back to screen for final drawing
    love.graphics.setCanvas()
    love.graphics.draw(virtualCanvas, 0, 0)

    -- debug stats
    if debugstats then
        love.graphics.setFont(debugfont)
        local stats = love.graphics.getStats()
        love.graphics.print("Draws: " .. stats.drawcalls .. "\nGfx Mem: " .. string.format("%.2f",stats.texturememory/1024/1024) .. "\nVolume: " .. config.sounds.volume, 10, love.graphics.getHeight() - 40)
    end
end

-- handle keyboard events
function love.keypressed(key)
    if game then
        -- game code regardless of pausing
        if endgame then
            -- if the game has ended (but not back in menu yet)
            game = false
            menu = "main"
            endgame = false
            pause = false
        elseif not paused then
            if key == config.controls[config.controlindex.kb][config.controlindex.menu] then
                paused = true
            end

            -- temp for end state demo --> this will simulate an end game state
            if key == "q" then
                endgame = true
                return -- this is just for the demo -> you will want to adjust this logic... 
            end
            -- game code
        else
            -- if game is paused
            love.audio.play(menubip)
            if menu == "options" then
                optionsmenu:keypressed(key)
            elseif menu == "controls" then
                controlsmenu:keypressed(key)
            else
                pausemenu:keypressed(key)
            end

        end
    else
        -- play menu moving sound
        
        love.audio.play(menubip)
        -- menu code
        if menu == "main" then
            mainmenu:keypressed(key)
        elseif menu == "options" then 
            optionsmenu:keypressed(key)
        elseif menu == "controls" then 
            controlsmenu:keypressed(key)
        elseif menu == "splash" then
            splash:keypressed(key)
        end
    end
end

-- handle gamepad/joystick events
function love.gamepadpressed(js, button)
    local key = nil
    
    -- find button in gamepad #1 control settings and map to kb equivalent
    for i, v in ipairs(config.controls[config.controlindex.gamepad]) do
        if button == v then
            key = config.controls[config.controlindex.kb][i]
        end
    end

    -- pass the mapped control to the keypress funtion
    if game then
        -- game code regardless of pausing
        if endgame then
            -- if the game has ended (but not back in menu yet)
            game = false
            menu = "main"
            endgame = false
            pause = false            
        elseif not paused then
            if button == config.controls[config.controlindex.gamepad][config.controlindex.menu] then
                paused = true
            end

            -- game code
        else
            -- if game is paused
            love.audio.play(menubip)
            if menu == "options" then
                optionsmenu:keypressed(key)
            elseif menu == "controls" then
                controlsmenu:keypressed(key, button)
            else
                pausemenu:keypressed(key)
            end

        end


    else
        -- play menu moving sound
        
        love.audio.play(menubip)
        -- menu code
        if menu == "main" then
            mainmenu:keypressed(key)
        elseif menu == "options" then 
            optionsmenu:keypressed(key)
        elseif menu == "controls" then 
            controlsmenu:keypressed(key, button)
        elseif menu == "splash" then
            splash:keypressed(key)            
        end
    end
end

function love.mousepressed(button)

    if game then
        -- game code regardless of pausing
        if endgame then

        elseif not paused then
            if key == "escape" then
                paused = true
            end
            -- game code
        else
            -- if game is paused
            love.audio.play(menubip)
            if menu == "options" then
                -- optionsmenu:keypressed(key)
            elseif menu == "controls" then
                controlsmenu:mousepressed(x, y, button)
            else
                -- pausemenu:keypressed(key)
            end

        end
    else
        -- play menu moving sound
        
        love.audio.play(menubip)
        -- menu code
        if menu == "main" then
            -- mainmenu:keypressed(key)
        elseif menu == "options" then 
            -- optionsmenu:keypressed(key)
        elseif menu == "controls" then 
            controlsmenu:mousepressed(x, y, button)
        end
    end
end

function love.joystickadded(js)
    print("added: " .. js:getName())
end

function love.joystickremoved(js)
    print("removed: " .. js:getName())    
end

function resetVirtualCanvas()
    virtualCanvas = love.graphics.newCanvas(config.game.width * config.game.scale, config.game.height * config.game.scale)
    love.window.setMode(virtualCanvas:getWidth(), virtualCanvas:getHeight())
end

function saveConfig()
    -- generate json and save
    local str = json.encode(config, {indent = true})
    print(str)
    local ok, msg = love.filesystem.write("config.json", str)
    if not(ok) then
        print("error: " .. msg)
    else
        print("saved")
    end      
end