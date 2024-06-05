-- dodge settings
local dodge_button_timer = 0
local dodge_length = 0.1
local dodge_cooldown = 0
local dodge_cooldown_period = 5

-- weapon hitbox offsets
local weapon_offset_left = 40
local weapon_offset_right = 37
local weapon_offset_front = 50
local weapon_offset_back = -40
local weapon_offset_vertical = - 15

--#regionAttacking = false
local Attacking = false

function Update_dodge(dt)

    -- registers the dodge input
    Dodge = love.keyboard.isDown('space')
    -- records the time the dodge button is held
    if Dodge then
        dodge_button_timer = dodge_button_timer + dt
    else
        -- resets the ticker if dodge button released
        dodge_cooldown = math.max(0, dodge_cooldown - dt)
        if dodge_cooldown == 0 and not Dodge then
            dodge_button_timer = 0
            dodge_cooldown = dodge_cooldown_period
        end
    end

    -- checks if dodge button was held longer than allowed and sets the dodge cooldown to false or true
    if dodge_button_timer > dodge_length then
        Dodge_up = false
    else
        Dodge_up = true
    end
end

function Attack_logic()
    if love.mouse.isDown(1) then
        Moving = false
        Attacking = true
        if Equipped_sword == true then
            local cutInstance = CutSound:clone()
            if not CutSound:play() then
                cutInstance:play()
            end
        end
        if isColliding(sword_equipped_entity, goblin_entity) then
            local GoblinHurtInstance = GoblinHurtSound:clone()
            if not GoblinHurtSound:play() then
                GoblinHurtInstance:play()
            end
            if Character == "right" then
                goblin_entity.x = goblin_entity.x + 50
                goblin_entity.y = goblin_entity.y + 10
            elseif Character == "left" then
                goblin_entity.x = goblin_entity.x - 50
                goblin_entity.y = goblin_entity.y + 10
            elseif Character == "front" then
                goblin_entity.x = goblin_entity.x + 10
                goblin_entity.y = goblin_entity.y + 50
            elseif Character == "back" then
                goblin_entity.x = goblin_entity.x + 10
                goblin_entity.y = goblin_entity.y - 50
            end
        end
    else
        Attacking = false
    end
end

function Player_movement(dt)
    if love.keyboard.isDown('s') then
        Character = "front"
        player_entity.y = player_entity.y + player_entity.movespeed * dt
        Moving = true
    elseif love.keyboard.isDown('w') then
        Character = "back"
        player_entity.y = player_entity.y - player_entity.movespeed * dt
        Moving = true
    end
    if love.keyboard.isDown('a') then
        Character = "left"
        player_entity.x = player_entity.x - player_entity.movespeed * dt
        Moving = true
    elseif love.keyboard.isDown('d') then
        Character = "right"
        player_entity.x = player_entity.x + player_entity.movespeed * dt
        Moving = true
    end
end

function Attacking_hitbox_handler()
    if Equipped_sword and Attacking then
        sword_equipped_entity.hitboxHeight = Sword_equipped_hitbox_x
        sword_equipped_entity.hitboxWidth = Sword_equipped_hitbox_y
        if Character == "left" then
            sword_equipped_entity.x = player_entity.x - weapon_offset_left
            sword_equipped_entity.y = player_entity.y - weapon_offset_vertical
        elseif Character == "right" then
            sword_equipped_entity.x = player_entity.x + weapon_offset_right
            sword_equipped_entity.y = player_entity.y - weapon_offset_vertical
        elseif Character == "front" then
            sword_equipped_entity.y = player_entity.y + weapon_offset_front
            sword_equipped_entity.x = player_entity.x
        elseif Character == "back" then
            sword_equipped_entity.y = player_entity.y + weapon_offset_back
            sword_equipped_entity.x = player_entity.x
        end
    else
        sword_equipped_entity.hitboxHeight = 0
        sword_equipped_entity.hitboxWidth = 0
    end
end

function Pick_up_sword()
    if isColliding(player_entity, sword_entity) then
        Equipped_sword = true
    end
    if Equipped_sword then
        sword_entity.hitboxHeight = 0
        sword_entity.hitboxWidth = 0
    end
end

function Player_touches_goblin()
    if isColliding(player_entity, goblin_entity) then
        Character_hurt:play()
    end
end