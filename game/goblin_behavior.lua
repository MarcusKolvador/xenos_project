local Entity = require("entity")
local Goblin_entity = Entity.Goblin_entity
local Health_entity = Entity.Health_entity
local health_drop_probability = 1 
local kills_to_drop_healing = 0
local spawn_distance = 5
local healing_value = 30

function SpawnGoblin(player_entity)
    local middle_x_min = player_entity.x - spawn_distance
    local middle_x_max = player_entity.x + spawn_distance
    local middle_y_min = player_entity.y - spawn_distance
    local middle_y_max = player_entity.y + spawn_distance

    repeat
        Goblin_x = math.random(0, MapWidth - 60)
        Goblin_y = math.random(0, MapHeight - 60)
    until not (Goblin_x >= middle_x_min and Goblin_x <= middle_x_max and Goblin_y >= middle_y_min and Goblin_y <= middle_y_max)

    goblin_entity = Goblin_entity:new(Goblin_x, Goblin_y, goblin_sprite, Goblin_hitbox_x, Goblin_hitbox_y, Goblin_entity_movespeed, Goblin_entity_health, Goblin_entity_damage, Goblin_direction)
    table.insert(Enemies, goblin_entity)
end

function Goblin_move(dt)
    for _, goblin_entity in ipairs(Enemies) do
        -- difference between goblin and player x, y
        local difference_x = goblin_entity.x - player_entity.x
        local difference_y = goblin_entity.y - player_entity.y
        if math.abs(difference_x) > math.abs(difference_y) then
            if difference_x > 0 then
                goblin_entity.direction = "left"
                goblin_entity.x = goblin_entity.x - goblin_entity.movespeed * dt
            elseif difference_x < 0 then
                goblin_entity.direction = "right"
                goblin_entity.x = goblin_entity.x + goblin_entity.movespeed * dt
            end
        else
            if difference_y > 0 then
                goblin_entity.direction = "back"
                goblin_entity.y = goblin_entity.y - goblin_entity.movespeed * dt
            elseif difference_y < 0 then
                goblin_entity.direction = "front"
                goblin_entity.y = goblin_entity.y + goblin_entity.movespeed * dt
            end
        end
    end
end

function Draw_goblin()
    for _, goblin_entity in ipairs(Enemies) do
        local key = "goblin_" .. goblin_entity.direction
        if goblin_entity.isDamaged or not Player_controls then
            love.graphics.setColor(1, 0, 0)
            love.graphics.draw(Spritesheets[key], Frames[key][CurrentGoblinFrame], goblin_entity.x - Goblin_hitbox_x - Goblin_hitbox_offset_x, goblin_entity.y - Goblin_hitbox_y
            - Goblin_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(Spritesheets[key], Frames[key][CurrentGoblinFrame], goblin_entity.x - Goblin_hitbox_x - Goblin_hitbox_offset_x, goblin_entity.y - Goblin_hitbox_y
            - Goblin_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
        end
        love.graphics.draw(Spritesheets[key], Frames[key][CurrentGoblinFrame], goblin_entity.x - Goblin_hitbox_x - Goblin_hitbox_offset_x, goblin_entity.y - Goblin_hitbox_y
        - Goblin_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    end
end

function Goblin_death()
    local aliveGoblins = {}
    for _, goblin_entity in ipairs(Enemies) do
        if goblin_entity.health <= 0 then
            GoblinHurtSound:stop()
            Goblin_death_sound:play()
            DropHealth(goblin_entity)
            goblin_entity = nil
            player_entity.kills = player_entity.kills + 1
        else
            table.insert(aliveGoblins, goblin_entity)
        end
    end
    Enemies = aliveGoblins
end

function GoblinRespawn(dt)
    SpawnTimer = SpawnTimer + dt
    if SpawnTimer >= SpawnInterval then
        SpawnTimer = 0
        SpawnGoblin(player_entity)
        EnemiesSpawned = EnemiesSpawned + 1
    end
end

function DropHealth(goblin_entity)
    local randomNumber = math.random()
    if randomNumber < health_drop_probability and player_entity.kills > kills_to_drop_healing then
        health_entity = Health_entity:new(goblin_entity.x, goblin_entity.y, health_sprite, Sword_hitbox_x, Sword_hitbox_y, healing_value, Health_item_timer)
        table.insert(Drops, health_entity)
    end
end