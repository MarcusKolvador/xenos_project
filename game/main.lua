-- Imports
local Entity = require("entity")
local Player_entity = Entity.Player_entity
local Sword_entity = Entity.Sword_entity
require("dodge")


-- Constants
local FRAME_WIDTH = 32
local FRAME_HEIGHT = 32
local FRAME_COUNT = 4
local MOVE_SPEED = {normal = 150, dodge = 700}
local FRAME_TIME = 0.25

-- Variables
local backgroundMusic
local background
local spritesheets = {}
local frames = {}
local currentFrame = 1
local elapsedTime = 0
local x, y
local mapWidth, mapHeight
local moving = false
local scaleFactor = 3
local character = "front"
local equipped_sword = false
-- Global variables
Dodge = false
Dodge_up = false


-- Load assets and initialize
function love.load()
    -- Load music
    backgroundMusic = love.audio.newSource("assets/demon-slayer-8687.mp3", "stream")
    love.audio.play(backgroundMusic)
    backgroundMusic:setLooping(true)

    -- Load images
    love.graphics.setDefaultFilter('nearest', 'nearest')
    background = love.graphics.newImage("assets/grass.png")
    spritesheets = {
        -- Character sprites
        left = love.graphics.newImage("assets/avatar_left.png"),
        right = love.graphics.newImage("assets/avatar_right.png"),
        back = love.graphics.newImage("assets/avatar_back.png"),
        front = love.graphics.newImage("assets/avatar_front.png"),
        -- Character status effects
        dodge_ui = love.graphics.newImage("assets/dodge.png"),
        -- Weapon equipped sprites
        sword_equipped = love.graphics.newImage("assets/sword_equipped.png"),
        sword_equipped_right = love.graphics.newImage("assets/sword_equipped_right.png"),
    }
    -- Item sprites
    sword_sprite = love.graphics.newImage("assets/sword.png")
    
    -- Read frames from sprites, assuming they're placed horizontally, at 4 frames
    for sprite, spritesheet in pairs(spritesheets) do
        frames[sprite] = {}
        for i = 0, FRAME_COUNT - 1 do
            table.insert(frames[sprite], love.graphics.newQuad(i * FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT, spritesheet:getDimensions()))
        end
    end

    -- Create sword entity
    sword_entity = Sword_entity:new(100, 360, sword_sprite, 16, 16)

    -- Initialize player position to the center of the map
    updateMapSize()
    x, y = mapWidth / 2, mapHeight / 2
    -- Create player entity
    player_entity = Player_entity:new(x, y, spritesheets["front"], 32, 32)
end

-- Update game state
function love.update(dt)
    -- set speed depending on if dodging or not
    local moveSpeed = moving and (Dodge and Dodge_up and MOVE_SPEED.dodge or MOVE_SPEED.normal) or 0
    moving = false

    -- Player movement logic
    if love.keyboard.isDown('s') then
        character = "front"
        player_entity.y = player_entity.y + moveSpeed * dt
        moving = true
    elseif love.keyboard.isDown('w') then
        character = "back"
        player_entity.y = player_entity.y - moveSpeed * dt
        moving = true
    end

    if love.keyboard.isDown('a') then
        character = "left"
        player_entity.x = player_entity.x - moveSpeed * dt
        moving = true
    elseif love.keyboard.isDown('d') then
        character = "right"
        player_entity.x = player_entity.x + moveSpeed * dt
        moving = true
    end

    -- registers the dodge input
    Dodge = love.keyboard.isDown('space')
    
    updateDodge(dt)

    -- picking up sword
    if isColliding(player_entity, sword_entity) then
        equipped_sword = true
    end

    -- Constrain player within map boundaries
    x = math.max(0, math.min(x, mapWidth - FRAME_WIDTH * scaleFactor))
    y = math.max(0, math.min(y, mapHeight - FRAME_HEIGHT * scaleFactor))

    -- Update animation
    if moving then
        elapsedTime = elapsedTime + dt
        if elapsedTime >= FRAME_TIME then
            elapsedTime = elapsedTime - FRAME_TIME
            currentFrame = (currentFrame % FRAME_COUNT) + 1
        end
    else
        currentFrame = 1
    end
end

-- Render the game
function love.draw()
    -- Draw background
    for bg_y = 0, love.graphics.getHeight() / (background:getHeight() * scaleFactor) do
        for bg_x = 0, love.graphics.getWidth() / (background:getWidth() * scaleFactor) do
            love.graphics.draw(background, bg_x * background:getWidth() * scaleFactor, bg_y * background:getHeight() * scaleFactor, 0, scaleFactor)
        end
    end

    -- draws sword_entity if not equipped
    if not equipped_sword then
        love.graphics.draw(sword_sprite, sword_entity.x - 16, sword_entity.y - 16, 0, scaleFactor/2, scaleFactor/2)
    end
    
    -- Draw player
    love.graphics.draw(spritesheets[character], frames[character][currentFrame], player_entity.x - 16, player_entity.y - 16, 0, scaleFactor, scaleFactor)

    -- Draw equipped sword
    if equipped_sword then
        if character ~= "right" then
            love.graphics.draw(spritesheets["sword_equipped"], frames["sword_equipped"][currentFrame], player_entity.x - 16, player_entity.y - 16, 0, scaleFactor, scaleFactor)
        else
            love.graphics.draw(spritesheets["sword_equipped_right"], frames["sword_equipped_right"][currentFrame], player_entity.x - 16, player_entity.y - 16, 0, scaleFactor, scaleFactor)
        end
    end

    -- Draw UI
    if not Dodge_up then
        love.graphics.draw(spritesheets["dodge_ui"], frames["dodge_ui"][currentFrame], player_entity.x - 16, player_entity.y - 16, 0, scaleFactor, scaleFactor)
    end
end

-- Handle window resizing
function love.resize(w, h)
    updateMapSize()
end

-- Update map size based on window dimensions
function updateMapSize()
    mapWidth, mapHeight = love.graphics.getWidth(), love.graphics.getHeight()
end

function isColliding(a, b)
    
    -- Update positions
    local leftA, rightA, topA, bottomA = a.x, a.x + a.hitboxWidth * scaleFactor, a.y, a.y + a.hitboxHeight * scaleFactor
    local leftB, rightB, topB, bottomB = b.x, b.x + b.hitboxWidth * scaleFactor, b.y, b.y + b.hitboxHeight * scaleFactor

    -- Check for collision
    if rightA > leftB and leftA < rightB and bottomA > topB and topA < bottomB then
        return true
    else
        return false
    end
end
