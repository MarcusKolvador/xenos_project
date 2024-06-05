-- Imports
local Entity = require("entity")
local Player_entity = Entity.Player_entity
local Sword_entity = Entity.Sword_entity
local Sword_equipped_entity = Entity.Sword_equipped_entity
require("player_behavior")
require("collide")
require("spawn_enemies")
require("helpers")
require("audio")
require("images")
-- Constants
FRAME_WIDTH = 32
FRAME_HEIGHT = 32
FRAME_COUNT = 4
local MOVE_SPEED = {normal = 150, dodge = 700}
-- Variables
spritesheets = {}
frames = {}
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
CurrentFrame = 1
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
    Load_sounds()
    Load_images()
    -- Initialize the center of the map
    x, y = MapWidth / 2, MapHeight / 2
    -- Initialize entities
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
    player_entity.x, player_entity.y = Boundary_handler(player_entity.x, player_entity.y)
    goblin_entity.x, goblin_entity.y = Boundary_handler(goblin_entity.x, goblin_entity.y)
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
    love.graphics.draw(spritesheets[Character], frames[Character][CurrentFrame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x, player_entity.y
    - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    -- Draw equipped sword
    if Equipped_sword then
        if Character~= "right" then
            love.graphics.draw(spritesheets["sword_equipped"], frames["sword_equipped"][CurrentFrame], player_entity.x - Player_hitbox_x
            - Player_hitbox_offset_x - sword_equipped_offset_left_x, player_entity.y - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
        else
            love.graphics.draw(spritesheets["sword_equipped_right"], frames["sword_equipped_right"][CurrentFrame], player_entity.x - Player_hitbox_x
            - Player_hitbox_offset_x - sword_equipped_offset_right_x, player_entity.y - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
        end
    end

    -- Draw hitboxes
    if Hitbox_debug == true then
        debug()
    end

    -- Draw UI
    if not Dodge_up then
        love.graphics.draw(spritesheets["dodge_ui"], frames["dodge_ui"][CurrentFrame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x, player_entity.y - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    end
end