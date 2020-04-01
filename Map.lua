--[[
    Contains tile data and necessary code for rendering a tile map the 
    screen 
]]
require 'Util'

Map = Class{}

TILE_BRICK = 1
TILE_EMPTY = -1

-- cloud tiles
CLOUD_LEFT = 6
CLOUD_RIGHT = 7

-- bush tiles
BUSH_LEFT = 2
BUSH_RIGHT = 3

-- mushroom tiles
MUSHROOM_TOP = 10
MUSHROOM_BOTTOM = 11

-- jump block 
JUMP_BLOCK = 5

-- a speed to multiply delta time to scroll map; smooth value
local SCOLLS_SPEED = 62

-- constructor for our map object
function Map:init()
    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    -- generate a quad (individual frame/sprite) for each tile
    self.tileSprites = generateQuads(self.spritesheet, 16, 16)

    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    -- camera offsets 
    self.camX = 0
    self.camY = -3
     
    -- cache width and height of map in pixels
    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    -- filling the map width empty tiles
    for y = 1, self.mapHeight / 2 do
        for x = 1, self.mapWidth do

            -- support for multiple sheets per tile; storing tiles as tables
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    -- begin generating the terrain using vertical scan lines 
    local x = 1 
    while x < self.mapWidth do 
        
        -- 2% chance to generate a cloud
        -- make sure we're 2 tiles from edge at least 
        if x < self.mapWidth - 2 then
            if math.random(20) == 1 then 
                
                -- choose a random vertical spot above where blocks/pipes generate 
                local cloudStart = math.random(self.mapHeight / 2 - 6)

                self:setTile(x, cloudStart, CLOUD_LEFT)
                self:setTile(x + 1, cloudStart, CLOUD_RIGHT)
            end
        end

        -- 5% chance to generate a mushroom
        if  math.random(20) == 1 then
            -- left side of pipe 
            self:setTile(x, self.mapHeight / 2 - 2, MUSHROOM_TOP)
            self:setTile(x, self.mapHeight / 2 - 1, MUSHROOM_BOTTOM)
        end
    end

    -- Starts halfway down the map, populates with bricks
    for y = self.mapHeight / 2, self.mapHeight do
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_BRICK)
        end 
    end
end

function Map:update(dt)
    if love.keyboard.isDown('w') then
        -- up movement 
        self.camY = math.max(0, math.floor(self.camX + dt * -SCOLLS_SPEED))
    elseif love.keyboard.isDown('a') then
        -- left movement 
        self.camX = math.max(math.floor(self.camX + dt * -SCOLLS_SPEED))
    elseif love.keyboard.isDown('s') then
        -- down movement
        self.camY = math.min(self.mapHeightPixels - VIRTUAL_HEIGHT, math.floor(self.camX + dt * SCOLLS_SPEED))
    elseif love.keyboard.isDown('d') then
        -- right movement
        self.camX = math.min(self.mapWidthPixels - VIRTUAL_WIDTH, math.floor(self.camX + dt * SCOLLS_SPEED))
    end   
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, tile)
    self.tiles[(y - 1 ) * self.mapWidth + x ] = tile
end

-- renders our map to the screen, to be called by 
function Map:render()
    for y = 1, self.mapHeight do
        for  x = 1, self.mapWidth do
            if self:getTile(x, y) ~= TILE_EMPTY then
                love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
       
            end
        end
    end   
end