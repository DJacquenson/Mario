Class = require 'class'
push = require 'push'

require 'Map'

-- Actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- close resolution to NES but 16:9
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- an object to contain our map data 
require 'Util'

-- Performes initialization of all objects and data needed by program 
function love.load()
    map = Map()

    -- makes upscaling look pixel-y instead of blurry 
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- sets up virtual sceen resolution for an authentic retro feel
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false, 
        vsync = true
    })

end

-- called whenever window is resized 
function love.resize(w, h)
    push:resize(w, h)
end 

-- called whenever a key is pressed 
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- called every frame, width dt passed in as delta in time since last frame 
function love.update(dt)
    map:update(dt)
end 

function love.draw()

    -- begin 
    push:apply('start')

    love.graphics.translate(math.floor(-map.camX), math.floor(-map.camY))

    -- Clear screen using Mario Background blue
    love.graphics.clear(108/255, 140/ 255, 255/ 255, 255/255)

    love.graphics.print("Hello, world!")
    
    -- renders our map object onto the screen  
    map:render()

    -- end virtual resolution 
    push:apply('end')
end