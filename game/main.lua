-- Imports
local Entity = require("entity")
local Player_entity = Entity.Player_entity
local Sword_entity = Entity.Sword_entity
require("dodge")
require("collide")
require("spawn_enemies")


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
local moving = false
local character = "front"
local equipped_sword = false
local player_hitbox_x = 24
local player_hitbox_y = 30
local sword_hitbox_x = 16
local sword_hitbox_y = 16
local goblin_hitbox_offset_x = 14
local goblin_hitbox_offset_y = 33
local player_hitbox_offset_x = 4
local player_hitbox_offset_y = -8
local hitbox_debug = false

-- Global variables
Dodge = false
Dodge_up = false
ScaleFactor = 3
MapWidth, MapHeight = love.graphics.getWidth(), love.graphics.getHeight()
Goblin_hitbox_x = 20
Goblin_hitbox_y = 20


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

    -- Enemies
    goblin_sprite = love.graphics.newImage("assets/goblin.png")
    
    -- Read frames from sprites, assuming they're placed horizontally, at 4 frames
    for sprite, spritesheet in pairs(spritesheets) do
        frames[sprite] = {}
        for i = 0, FRAME_COUNT - 1 do
            table.insert(frames[sprite], love.graphics.newQuad(i * FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT, spritesheet:getDimensions()))
        end
    end

    -- Create goblin entity
    goblin_entity = SpawnGoblin()

    -- Create sword entity
    sword_entity = Sword_entity:new(MapWidth / 2 - MapWidth / 4, MapHeight / 2 - MapHeight / 4, sword_sprite, sword_hitbox_x, sword_hitbox_y)

    -- Initialize player position to the center of the map
    x, y = MapWidth / 2, MapHeight / 2
    -- Create player entity
    player_entity = Player_entity:new(x, y, spritesheets["front"], player_hitbox_x, player_hitbox_y)
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


    -- handle boundaries
    local minX, minY = 0, 0
    local maxX, maxY = love.graphics.getWidth(), love.graphics.getHeight()
    local newBoing = love.audio.newSource("assets/boing.mp3", "static")
    player_entity.x = math.max(minX, math.min(maxX, player_entity.x))
    player_entity.y = math.max(minY, math.min(maxY, player_entity.y))

    if player_entity.x >= maxX then
        newBoing:play()
        player_entity.x = maxX - 20
    elseif player_entity.x <= minX then
        newBoing:play()
        player_entity.x = minX + 20
    end
    if player_entity.y >= maxY then
        newBoing:play()
        player_entity.y = maxY - 20
    elseif player_entity.y <= minY then
        newBoing:play()
        player_entity.y = minY + 20
    end

    UpdateDodge(dt)

    -- picking up sword
    if isColliding(player_entity, sword_entity) then
        equipped_sword = true
    end

    -- colliding with goblin
    if isColliding(player_entity, goblin_entity) then
        newBoing:play()
    end

    -- Constrain player within map boundaries
    x = math.max(0, math.min(x, MapWidth - FRAME_WIDTH * ScaleFactor))
    y = math.max(0, math.min(y, MapHeight - FRAME_HEIGHT * ScaleFactor))

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
    for bg_y = 0, love.graphics.getHeight() / (background:getHeight() * ScaleFactor) do
        for bg_x = 0, love.graphics.getWidth() / (background:getWidth() * ScaleFactor) do
            love.graphics.draw(background, bg_x * background:getWidth() * ScaleFactor, bg_y * background:getHeight() * ScaleFactor, 0, ScaleFactor)
        end
    end

    -- draws sword_entity if not equipped
    if not equipped_sword then
        love.graphics.draw(sword_sprite, sword_entity.x - sword_hitbox_x, sword_entity.y - sword_hitbox_y, 0, ScaleFactor / 2, ScaleFactor / 2)
    end

    -- Draw goblin
    love.graphics.draw(goblin_sprite, goblin_entity.x - Goblin_hitbox_x - goblin_hitbox_offset_x, goblin_entity.y - Goblin_hitbox_y - goblin_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    
    -- Draw player
    love.graphics.draw(spritesheets[character], frames[character][currentFrame], player_entity.x - player_hitbox_x - player_hitbox_offset_x, player_entity.y - player_hitbox_y - player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    
    -- Draw equipped sword
    if equipped_sword then
        if character ~= "right" then
            love.graphics.draw(spritesheets["sword_equipped"], frames["sword_equipped"][currentFrame], player_entity.x - 16, player_entity.y - 16, 0, ScaleFactor, ScaleFactor)
        else
            love.graphics.draw(spritesheets["sword_equipped_right"], frames["sword_equipped_right"][currentFrame], player_entity.x - 16, player_entity.y - 16, 0, ScaleFactor, ScaleFactor)
        end
    end

    -- Draw hitboxes
    if hitbox_debug == true then
        debug()
    end

    -- Draw UI
    if not Dodge_up then
        love.graphics.draw(spritesheets["dodge_ui"], frames["dodge_ui"][currentFrame], player_entity.x - 16, player_entity.y - 16, 0, ScaleFactor, ScaleFactor)
    end
end


function debug()
    if not equipped_sword then
        love.graphics.rectangle("line", sword_entity.x - FRAME_WIDTH / 2, sword_entity.y - FRAME_HEIGHT / 2, sword_hitbox_x * ScaleFactor, sword_hitbox_y * ScaleFactor)
    end
    love.graphics.rectangle("line", goblin_entity.x - FRAME_WIDTH / 2, goblin_entity.y  - FRAME_HEIGHT / 2, Goblin_hitbox_x * ScaleFactor, Goblin_hitbox_y * ScaleFactor)
    love.graphics.rectangle("line", player_entity.x - FRAME_WIDTH / 2, player_entity.y - FRAME_HEIGHT / 2, player_hitbox_x * ScaleFactor, player_hitbox_y * ScaleFactor)
end

function love.keypressed(key)
    if key == "k" then
        hitbox_debug = not hitbox_debug
    end
end