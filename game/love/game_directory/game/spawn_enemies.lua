local Entity = require("entity")
local Goblin_entity = Entity.Goblin_entity

function SpawnGoblin()
    local middle_x_min = MapWidth * 0.4
    local middle_x_max = MapWidth * 0.6
    local middle_y_min = MapHeight * 0.4
    local middle_y_max = MapHeight * 0.6

    repeat
        goblin_x = math.random(0, MapWidth - 60)
        goblin_y = math.random(0, MapHeight - 60)
    until not (goblin_x >= middle_x_min and goblin_x <= middle_x_max and goblin_y >= middle_y_min and goblin_y <= middle_y_max)

    goblin_entity = Goblin_entity:new(goblin_x, goblin_y, goblin_sprite, Goblin_hitbox_x, Goblin_hitbox_y, Goblin_entity_movespeed, Goblin_entity_health, Goblin_entity_damage)
    table.insert(Enemies, goblin_entity)
end

function Goblin_move(dt)
    for _, goblin_entity in ipairs(Enemies) do
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
end

function Draw_goblin()
    for _, goblin_entity in ipairs(Enemies) do
        love.graphics.draw(Spritesheets["goblin_front"], Frames["goblin_front"][CurrentGoblinFrame], goblin_entity.x - Goblin_hitbox_x - Goblin_hitbox_offset_x, goblin_entity.y - Goblin_hitbox_y
        - Goblin_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    end
end

function Goblin_death()
    local aliveGoblins = {}

    for _, goblin_entity in ipairs(Enemies) do
        if goblin_entity.health <= 0 then
            GoblinHurtSound:stop()
            Goblin_death_sound:play()
            player_entity.kills = player_entity.kills + 1
        else
            table.insert(aliveGoblins, goblin_entity)
        end
    end

    Enemies = aliveGoblins
end