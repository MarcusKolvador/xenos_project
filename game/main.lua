-- Imports
local Entity = require("entity")
local Player_entity = Entity.Player_entity
local Sword_entity = Entity.Sword_entity
local Sword_equipped_entity = Entity.Sword_equipped_entity
require("player_behavior")
require("collide")
require("spawn_enemies")
require("helpers")
-- Constants
FRAME_WIDTH = 32
FRAME_HEIGHT = 32
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
Moving = false
Character = "front"
-- hitboxes
Player_hitbox_x = 24
Player_hitbox_y = 30
Sword_hitbox_x = 16
Sword_hitbox_y = 16
Sword_equipped_hitbox_x = 15
Sword_equipped_hitbox_y = 15
-- model offsets in regard to entity
Goblin_hitbox_offset_x = 14
Goblin_hitbox_offset_y = 33
Player_hitbox_offset_x = 4
Player_hitbox_offset_y = -8
local sword_equipped_offset_left_x = 10
local sword_equipped_offset_right_x = - 11
-- Global variables
Hitbox_debug = false
Dodge = false
Dodge_up = false
ScaleFactor = 3
MapWidth, MapHeight = love.graphics.getWidth(), love.graphics.getHeight()
Goblin_hitbox_x = 20
Goblin_hitbox_y = 20
Player_entity_movespeed = 100
Goblin_entity_movespeed = 30
Equipped_sword = false


-- Load assets and initialize
function love.load()
    -- Load music
    backgroundMusic = love.audio.newSource("assets/demon-slayer-8687.mp3", "stream")
    love.audio.play(backgroundMusic)
    backgroundMusic:setLooping(true)
    -- Load sounds
    CutSound = love.audio.newSource("assets/cut_sound.mp3", "static")
    Character_hurt = love.audio.newSource("assets/character_ouch.mp3", "static")
    GoblinHurtSound = love.audio.newSource("assets/goblin_hurt_sound.mp3", "static")

    -- Load images
    love.graphics.setDefaultFilter('nearest', 'nearest')
    background = love.graphics.newImage("assets/grass.png")
    spritesheets = {
        -- Character sprites
        left = love.graphics.newImage("assets/avatar_left.png"),
        right = love.graphics.newImage("assets/avatar_right.png"),
        back = love.graphics.newImage("assets/avatar_back.png"),
        front = love.graphics.newImage("assets/avatar_front.png"),
        -- Character attacks
        attack_front = love.graphics.newImage("assets/attack_front.png"),
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

    -- Initialize the center of the map
    x, y = MapWidth / 2, MapHeight / 2

    -- Entities
    goblin_entity = SpawnGoblin()
    sword_entity = Sword_entity:new(MapWidth / 2 - MapWidth / 4, MapHeight / 2 - MapHeight / 4, sword_sprite, Sword_hitbox_x, Sword_hitbox_y)
    player_entity = Player_entity:new(x, y, spritesheets["front"], Player_hitbox_x, Player_hitbox_y, Player_entity_movespeed)
    sword_equipped_entity = Sword_equipped_entity:new(0, 0, spritesheets["sword_equipped"], 0, 0)  -- 0 hitbox as it is not yet equipped
end

-- Update game state
function love.update(dt)
    -- set speed depending on if dodging or not
    player_entity.movespeed = Moving and (Dodge and Dodge_up and MOVE_SPEED.dodge or MOVE_SPEED.normal) or 0
    Moving = false
    -- Constrain player within map boundaries
    x = math.max(0, math.min(x, MapWidth - FRAME_WIDTH * ScaleFactor))
    y = math.max(0, math.min(y, MapHeight - FRAME_HEIGHT * ScaleFactor))

    -- Player movement logic
    Player_movement(dt)

    -- Goblin movement logic
    Goblin_move(dt)

    -- attack logic
    Attack_logic()

    -- handle boundaries
    Boundary_handler()

    -- Dodge handling
    Update_dodge(dt)

    -- picking up sword
    Pick_up_sword()

    -- Attack_logic
    Attacking_hitbox_handler()

    -- Effects for player touching goblin
    Player_touches_goblin()

    -- Update animation
    Animation_updater(dt)
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
    if not Equipped_sword then
        love.graphics.draw(sword_sprite, sword_entity.x - Sword_hitbox_x, sword_entity.y - Sword_hitbox_y, 0, ScaleFactor / 2, ScaleFactor / 2)
    end

    -- Draw goblin
    love.graphics.draw(goblin_sprite, goblin_entity.x - Goblin_hitbox_x - Goblin_hitbox_offset_x, goblin_entity.y - Goblin_hitbox_y
    - Goblin_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    
    -- Draw player
    love.graphics.draw(spritesheets[Character], frames[Character][currentFrame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x, player_entity.y
    - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    -- Draw equipped sword
    if Equipped_sword then
        if Character~= "right" then
            love.graphics.draw(spritesheets["sword_equipped"], frames["sword_equipped"][currentFrame], player_entity.x - Player_hitbox_x
            - Player_hitbox_offset_x - sword_equipped_offset_left_x, player_entity.y - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
        else
            love.graphics.draw(spritesheets["sword_equipped_right"], frames["sword_equipped_right"][currentFrame], player_entity.x - Player_hitbox_x
            - Player_hitbox_offset_x - sword_equipped_offset_right_x, player_entity.y - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
        end
    end

    -- Draw hitboxes
    if Hitbox_debug == true then
        debug()
    end

    -- Draw UI
    if not Dodge_up then
        love.graphics.draw(spritesheets["dodge_ui"], frames["dodge_ui"][currentFrame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x, player_entity.y - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    end
end

-----------------------------------------------------------------------------
-- Called on functions
-----------------------------------------------------------------------------


function Goblin_move(dt)
    if goblin_entity.x > player_entity.x then
        goblin_entity.x = goblin_entity.x - goblin_entity.movespeed * dt
    elseif goblin_entity.x < player_entity.x then
        goblin_entity.x = goblin_entity.x + goblin_entity.movespeed * dt
    end
    if goblin_entity.y > player_entity.y then
        goblin_entity.y = goblin_entity.y - goblin_entity.movespeed * dt
    elseif goblin_entity.y < player_entity.y then
        goblin_entity.y = goblin_entity.y + goblin_entity.movespeed * dt
    end
end

function Animation_updater(dt)
    if Moving then
        elapsedTime = elapsedTime + dt
        if elapsedTime >= FRAME_TIME then
            elapsedTime = elapsedTime - FRAME_TIME
            currentFrame = (currentFrame % FRAME_COUNT) + 1
        end
    else
        currentFrame = 1
    end
end