-- Base Entity class
local Entity = {}
Entity.__index = Entity

function Entity:new(x, y, sprite)
    local entity = {}
    setmetatable(entity, Entity)

    entity.x = x
    entity.y = y
    entity.sprite = sprite

    return entity
end

function Entity:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

-- Sword entity inheriting from Entity
local Sword_entity = setmetatable({}, { __index = Entity })

function Sword_entity:new(x, y, sprite, hitboxWidth, hitboxHeight)
    local sword_entity = Entity.new(self, x, y, sprite)  -- Call the Entity constructor
    sword_entity.hitboxWidth = hitboxWidth
    sword_entity.hitboxHeight = hitboxHeight
    setmetatable(sword_entity, Sword_entity)
    return sword_entity
end

-- Sword equipped entity
local Sword_equipped_entity = setmetatable({}, { __index = Entity })

function Sword_equipped_entity:new(x, y, sprite, hitboxWidth, hitboxHeight)
    local sword_equipped_entity = Entity.new(self, x, y, sprite)  -- Call the Entity constructor
    sword_equipped_entity.hitboxWidth = hitboxWidth
    sword_equipped_entity.hitboxHeight = hitboxHeight
    setmetatable(sword_equipped_entity, Sword_equipped_entity)
    return sword_equipped_entity
end

-- Player entity inheriting from Entity
local Player_entity = setmetatable({}, { __index = Entity })

function Player_entity:new(x, y, sprite, hitboxWidth, hitboxHeight, movespeed)
    local player_entity = Entity.new(self, x, y, sprite)  -- Call the Entity constructor
    player_entity.hitboxWidth = hitboxWidth
    player_entity.hitboxHeight = hitboxHeight
    player_entity.movespeed = movespeed
    setmetatable(player_entity, Player_entity)
    return player_entity
end

local Goblin_entity = setmetatable({}, { __index = Entity })

function Goblin_entity:new(x, y, sprite, hitboxWidth, hitboxHeight, movespeed)
    local goblin_entity = Entity.new(self, x, y, sprite)  -- Call the Entity constructor
    goblin_entity.hitboxWidth = hitboxWidth
    goblin_entity.hitboxHeight = hitboxHeight
    goblin_entity.movespeed = movespeed
    setmetatable(goblin_entity, Goblin_entity)
    return goblin_entity
end

-- Return the Entity class and its subclasses
return {
    Entity = Entity,
    Sword_entity = Sword_entity,
    Player_entity = Player_entity,
    Goblin_entity = Goblin_entity,
    Sword_equipped_entity = Sword_equipped_entity
}