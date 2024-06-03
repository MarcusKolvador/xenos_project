local Entity = require("entity")
local Goblin_entity = Entity.Goblin_entity

function SpawnGoblin()
    math.randomseed(os.time())
    local middle_x_min = MapWidth * 0.4
    local middle_x_max = MapWidth * 0.6
    local middle_y_min = MapHeight * 0.4
    local middle_y_max = MapHeight * 0.6

    repeat
        goblin_x = math.random(0, MapWidth - 50)
        goblin_y = math.random(0, MapHeight - 50)
    until not (goblin_x >= middle_x_min and goblin_x <= middle_x_max and goblin_y >= middle_y_min and goblin_y <= middle_y_max)

    goblin_entity = Goblin_entity:new(goblin_x, goblin_y, goblin_sprite, Goblin_hitbox_x, Goblin_hitbox_y)
    return goblin_entity
end