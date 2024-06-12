-- Imports
local Entity = require("entity")
local Player_entity = Entity.Player_entity
local Sword_entity = Entity.Sword_entity
local Sword_equipped_entity = Entity.Sword_equipped_entity
local Health_entity = Entity.Health_entity
require("player_behavior")
require("collide")
require("goblin_behavior")
require("helpers")
require("audio")
require("images")
-- Seed rng
math.randomseed(os.time())
-- Constants
FRAME_WIDTH = 32
FRAME_HEIGHT = 32
FRAME_COUNT = 4
local MOVE_SPEED = {normal = 150, dodge = 700}
-- Local variables
local isDamaged = false
local x, y
local kills = 0
-- Hitboxes
Player_hitbox_x = 24
Player_hitbox_y = 30
Sword_hitbox_x = 16
Sword_hitbox_y = 16
Sword_equipped_hitbox_x = 30
Sword_equipped_hitbox_y = 18
Goblin_hitbox_x = 20
Goblin_hitbox_y = 20
-- Model offsets in regard to entity
Goblin_hitbox_offset_x = 14
Goblin_hitbox_offset_y = 33
Player_hitbox_offset_x = 4
Player_hitbox_offset_y = -8
-- Player state
Player_controls = true
Moving = false
Equipped_sword = false
Attacking = false
Attack_finished = true
Dodge = false
Dodge_up = false
-- Stats
Player_entity_movespeed = 100
Goblin_entity_movespeed = 30
Goblin_entity_health = 50
Player_entity_health = 100
Sword_equipped_entity_damage = 30
Goblin_entity_damage = 30
-- Draw variables
Character = "front"
Goblin_direction = "front"
MapWidth, MapHeight = love.graphics.getWidth(), love.graphics.getHeight()
ScaleFactor = 3
FlashTimer = 0
CurrentFrame = 1
CurrentAttackFrame = 1
CurrentGoblinFrame = 1
Hitbox_debug = false
Enemies = {}
Drops = {}
Spritesheets = {}
Frames = {}
-- Gamestate variables
Wave = 1
EnemiesPerWave = 5
EnemiesSpawned = 0
SpawnTimer = 0
SpawnInterval = 2
DeathTimer = 0
Game_end = false
NewWave = true
NewWaveDisplayTimer = 0
local gameEndCountdown = 10

-- Load assets and initialize
function love.load()
    Load_sounds()
    Load_images()
    -- Initialize the center of the map
    x, y = MapWidth / 2, MapHeight / 2
    -- Initialize entities
    sword_entity = Sword_entity:new(MapWidth / 2 - MapWidth / 4, MapHeight / 2 - MapHeight / 4, sword_sprite, Sword_hitbox_x, Sword_hitbox_y)
    player_entity = Player_entity:new(x, y, Spritesheets["front"], Player_hitbox_x, Player_hitbox_y, Player_entity_movespeed, Player_entity_health, kills, isDamaged)
    sword_equipped_entity = Sword_equipped_entity:new(0, 0, Spritesheets["sword_equipped"], 0, 0, Sword_equipped_entity_damage)  -- 0 hitbox as it is not yet equipped
end

-- Update game state
function love.update(dt)
    -- Flash if damaged
    FlashRedTimer(dt, player_entity)
    if goblin_entity then
        for _, goblin_entity in ipairs(Enemies) do
            FlashRedTimer(dt, goblin_entity)
        end
    end
    -- set speed depending on if dodging or not
    player_entity.movespeed = Moving and (Dodge and Dodge_up and MOVE_SPEED.dodge or MOVE_SPEED.normal) or 0
    Moving = false
    -- Constrain player within map boundaries
    x = math.max(0, math.min(x, MapWidth - FRAME_WIDTH * ScaleFactor))
    y = math.max(0, math.min(y, MapHeight - FRAME_HEIGHT * ScaleFactor))
    -- Player movement logic
    Player_movement(dt)
    -- Goblin entity
    SpawnEnemies(dt)
    if goblin_entity then
        if Player_controls then
            Goblin_move(dt)
        else
            if DeathTimer <= gameEndCountdown then
                Goblin_move(dt)
            end
        end
        for _, goblin_entity in ipairs(Enemies) do
            goblin_entity.x, goblin_entity.y = Boundary_handler(goblin_entity.x, goblin_entity.y)
        end
        Player_touches_goblin(dt)
        Attacking_hitbox_handler()
        Goblin_death()
    end
    StopLogic(dt)

    -- Respawn goblin
    
    -- handle boundaries
    player_entity.x, player_entity.y = Boundary_handler(player_entity.x, player_entity.y)
    -- Handle player behavior
    Update_dodge(dt)
    Attack_logic(dt)
    Pick_up_sword()
    Animation_updater(dt)
    Player_death(dt)
    Player_touches_health()
    -- print(#Enemies, EnemiesSpawned, EnemiesPerWave, SpawnTimer, Wave, SpawnInterval, DeathTimer)
end

-- Render the game
function love.draw()
    -- Draw background
    Draw_background()
    -- draws sword_entity if not equipped
    Draw_sword()
    -- Draw goblin
    if goblin_entity then
        Draw_goblin()
    end
    if health_entity then
        Draw_health()
    end
    -- Draw player
    if Character ~= "back" then
        Draw_player()
        Attack_animation()
    else
        Attack_animation()
        Draw_player()
    end
    -- Draw equipped sword
    Draw_equipped_sword()
    -- Draw hitboexes if triggered with button "k"
    Draw_hitboxes()
    -- Draw dodge effect
    Draw_dodge_effect()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(Font)
    love.graphics.print("Health: " .. math.max(player_entity.health, 0), 10, 10)
    love.graphics.print("Kills: " .. player_entity.kills, 10, 40)

    if not Player_controls then
        Draw_loss()
    end
    if NewWave then
        Draw_wave_no()
    end
end




