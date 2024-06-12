local Entity = require("entity")
local Goblin_entity = Entity.Goblin_entity
local Health_entity = Entity.Health_entity
local health_drop_probability = 0.3
local kills_to_drop_healing = 10

function SpawnGoblin()
    local middle_x_min = MapWidth * 0.4
    local middle_x_max = MapWidth * 0.6
    local middle_y_min = MapHeight * 0.4
    local middle_y_max = MapHeight * 0.6

    repeat
        goblin_x = math.random(0, MapWidth - 60)
        goblin_y = math.random(0, MapHeight - 60)
    until not (goblin_x >= middle_x_min and goblin_x <= middle_x_max and goblin_y >= middle_y_min and goblin_y <= middle_y_max)

    goblin_entity = Goblin_entity:new(goblin_x, goblin_y, goblin_sprite, Goblin_hitbox_x, Goblin_hitbox_y, Goblin_entity_movespeed, Goblin_entity_health, Goblin_entity_damage, Goblin_direction)
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
        SpawnGoblin()
        EnemiesSpawned = EnemiesSpawned + 1
    end
end

function DropHealth(goblin_entity)
    local randomNumber = math.random()
    if randomNumber < health_drop_probability and player_entity.kills > kills_to_drop_healing then
        health_entity = Health_entity:new(goblin_entity.x, goblin_entity.y, health_sprite, Sword_hitbox_x, Sword_hitbox_y, 30)
        print(health_entity.healing)
        table.insert(Drops, health_entity)
    end
end