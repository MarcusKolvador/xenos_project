-- dodge settings
local dodge_button_timer = 0
local dodge_length = 0.1
local dodge_cooldown = 0
local dodge_cooldown_period = 5

-- weapon hitbox offsets
local weapon_offset_left = 40
local weapon_offset_right = 37
local weapon_offset_front = 45
local weapon_offset_back = - 20
local weapon_offset_vertical = - 15
local weapon_offset_horizontal = 22

-- enemy knockbacks
local goblin_knockback = 30

-- attack settings
local attack_duration = 0.2
local attack_timer = 0

-- draw settings
local sword_equipped_offset_left_x = 10
local sword_equipped_offset_right_x = - 11
local sword_attack_offset_y = - 23
local attacking_model_offset_side = 17

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

function Attack_logic(dt)
    if love.mouse.isDown(1) then
        attack_timer = attack_timer + dt
        if attack_timer < attack_duration then
            Moving = false
            Attacking = true
            if Equipped_sword == true then
                local cutInstance = CutSound:clone()
                if not CutSound:play() then
                    cutInstance:play()
                end
            end
            if goblin_entity then
                if isColliding(sword_equipped_entity, goblin_entity) then
                    local GoblinHurtInstance = GoblinHurtSound:clone()
                    goblin_entity.health = goblin_entity.health - sword_equipped_entity.damage
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
            end
        else
            Attacking = false
        end
    else
        Attacking = false
        attack_timer = 0
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
        sword_equipped_entity.hitboxWidth = Sword_equipped_hitbox_x
        sword_equipped_entity.hitboxHeight = Sword_equipped_hitbox_y
        if Character == "left" then
            sword_equipped_entity.x = player_entity.x - weapon_offset_left
            sword_equipped_entity.y = player_entity.y - weapon_offset_vertical
        elseif Character == "right" then
            sword_equipped_entity.x = player_entity.x + weapon_offset_right
            sword_equipped_entity.y = player_entity.y - weapon_offset_vertical
        elseif Character == "front" then
            sword_equipped_entity.y = player_entity.y + weapon_offset_front
            sword_equipped_entity.x = player_entity.x - weapon_offset_horizontal
        elseif Character == "back" then
            sword_equipped_entity.y = player_entity.y + weapon_offset_back
            sword_equipped_entity.x = player_entity.x - weapon_offset_horizontal
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
        player_entity.health = player_entity.health - goblin_entity.damage
        if player_entity.x < goblin_entity.x then
            player_entity.x = player_entity.x - goblin_knockback
        else
            player_entity.x = player_entity.x + goblin_knockback
        end
        if player_entity.y < goblin_entity.y then
            player_entity.y = player_entity.y - goblin_knockback
        else
            player_entity.y = player_entity.y + goblin_knockback
        end
    end
end

function Draw_dodge_effect()
    if not Dodge_up then
        love.graphics.draw(Spritesheets["dodge_ui"], Frames["dodge_ui"][CurrentFrame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x, player_entity.y - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
    end
end

function Draw_equipped_sword()
    if Equipped_sword and not Attacking then
        if Character~= "right" then
            love.graphics.draw(Spritesheets["sword_equipped"], Frames["sword_equipped"][CurrentFrame], player_entity.x - Player_hitbox_x
            - Player_hitbox_offset_x - sword_equipped_offset_left_x, player_entity.y - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
        else
            love.graphics.draw(Spritesheets["sword_equipped_right"], Frames["sword_equipped_right"][CurrentFrame], player_entity.x - Player_hitbox_x
            - Player_hitbox_offset_x - sword_equipped_offset_right_x, player_entity.y - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
        end
    end
end

function Draw_player()
    love.graphics.draw(Spritesheets[Character], Frames[Character][CurrentFrame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x, player_entity.y
    - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
end

function Attack_animation()
    local key = "sword_attack_" .. Character
    if Equipped_sword and Attacking then
        if Character == "front" or Character == "back" then
            love.graphics.draw(Spritesheets[key], Frames[key][CurrentAttackFrame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x, player_entity.y
            - Player_hitbox_y - sword_attack_offset_y , 0, ScaleFactor, ScaleFactor)
        elseif Character == "left" then
            love.graphics.draw(Spritesheets[key], Frames[key][CurrentAttackFrame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x - attacking_model_offset_side, player_entity.y
            - Player_hitbox_y - sword_attack_offset_y , 0, ScaleFactor, ScaleFactor)
        else
            love.graphics.draw(Spritesheets[key], Frames[key][CurrentAttackFrame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x + attacking_model_offset_side, player_entity.y
            - Player_hitbox_y - sword_attack_offset_y , 0, ScaleFactor, ScaleFactor)
        end
    end
end