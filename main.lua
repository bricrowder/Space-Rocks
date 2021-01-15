-- load json code modules
json = require ("external/dkjson")

-- load the configuration
config = json.opendecode("config/config.json")

-- the two main drawing canvases
nativeCanvas = love.graphics.newCanvas(config.game.width, config.game.height)
virtualCanvas = love.graphics.newCanvas(config.game.width * config.game.scale, config.game.height * config.game.scale)

-- load the menus/screens
mainmenu = require ("screens/mainmenu").init()
pausemenu = require ("screens/pausemenu").init()
optionsmenu = require ("screens/optionsmenu").init()
controlsmenu = require ("screens/controlsmenu").init()

-- initialize global game state variables
game = false        -- if game is playing or not, it is the menu otherwise really...
menu = "main"     -- the non-game menu you are on
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

        if not paused then
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

        if endgame then
            -- if the game has ended (but not back in menu yet)

        end
    else
        -- menu code
        if menu == "main" then
            mainmenu:update(dt)
        elseif menu == "options" then
            optionsmenu:update(dt)
        elseif menu == "controls" then
            controlsmenu:update(dt)
        end
    end
end

function love.draw()
    -- draw everything at native
    love.graphics.setCanvas(nativeCanvas)
    love.graphics.clear()

    if game then
        -- game code regardless of pausing

        if not paused then
            -- game code
            love.graphics.print("Press Escape to Quit", nativeCanvas:getWidth()/2 - 20, nativeCanvas:getHeight()/2)
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

        if endgame then
            -- if the game has ended (but not back in menu yet)
        end
    else
        -- menu code
        if menu == "main" then
            mainmenu:draw()
        elseif menu == "options" then
            optionsmenu:draw()
        elseif menu == "controls" then
            controlsmenu:draw()
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

function love.keypressed(key)
    if game then
        -- game code regardless of pausing
        if not paused then
            if key == "escape" then
                paused = true
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

        if endgame then
            -- if the game has ended (but not back in menu yet)
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
        end
    end
end

function resetVirtualCanvas()
    virtualCanvas = love.graphics.newCanvas(config.game.width * config.game.scale, config.game.height * config.game.scale)
    love.window.setMode(virtualCanvas:getWidth(), virtualCanvas:getHeight())
end