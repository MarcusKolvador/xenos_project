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
Sword_entity.__index = Sword_entity

function Sword_entity:new(x, y, sprite, hitboxWidth, hitboxHeight)
    local sword_entity = Entity.new(self, x, y, sprite)  -- Call the Entity constructor
    sword_entity.hitboxWidth = hitboxWidth
    sword_entity.hitboxHeight = hitboxHeight
    setmetatable(sword_entity, Sword_entity)
    return sword_entity
end

-- Sword equipped entity
local Sword_equipped_entity = setmetatable({}, { __index = Entity })

function Sword_equipped_entity:new(x, y, sprite, hitboxWidth, hitboxHeight, damage)
    local sword_equipped_entity = Entity.new(self, x, y, sprite)  -- Call the Entity constructor
    sword_equipped_entity.hitboxWidth = hitboxWidth
    sword_equipped_entity.hitboxHeight = hitboxHeight
    sword_equipped_entity.damage = damage
    setmetatable(sword_equipped_entity, Sword_equipped_entity)
    return sword_equipped_entity
end

-- Player entity inheriting from Entity
local Player_entity = setmetatable({}, { __index = Entity })

function Player_entity:new(x, y, sprite, hitboxWidth, hitboxHeight, movespeed, health, kills, isDamaged)
    local player_entity = Entity.new(self, x, y, sprite)  -- Call the Entity constructor
    player_entity.hitboxWidth = hitboxWidth
    player_entity.hitboxHeight = hitboxHeight
    player_entity.movespeed = movespeed
    player_entity.health = health
    player_entity.kills = kills
    player_entity.isDamaged = isDamaged
    setmetatable(player_entity, Player_entity)
    return player_entity
end

local Goblin_entity = setmetatable({}, { __index = Entity })

function Goblin_entity:new(x, y, sprite, hitboxWidth, hitboxHeight, movespeed, health, damage, direction, isDamaged)
    local goblin_entity = Entity.new(self, x, y, sprite)  -- Call the Entity constructor
    goblin_entity.hitboxWidth = hitboxWidth
    goblin_entity.hitboxHeight = hitboxHeight
    goblin_entity.movespeed = movespeed
    goblin_entity.health = health
    goblin_entity.damage = damage
    goblin_entity.direction = direction
    goblin_entity.isDamaged = isDamaged
    setmetatable(goblin_entity, Goblin_entity)
    return goblin_entity
end

local Health_entity = setmetatable({}, { __index = Entity })

function Health_entity:new(x, y, sprite, hitboxWidth, hitboxHeight, healing)
    local health_entity = Entity.new(self, x, y, sprite)  -- Call the Entity constructor
    health_entity.hitboxWidth = hitboxWidth
    health_entity.hitboxHeight = hitboxHeight
    health_entity.healing = healing
    setmetatable(health_entity, Health_entity)
    return health_entity
end

-- Return the Entity class and its subclasses
return {
    Entity = Entity,
    Sword_entity = Sword_entity,
    Player_entity = Player_entity,
    Goblin_entity = Goblin_entity,
    Health_entity = Health_entity,
    Sword_equipped_entity = Sword_equipped_entity,
}