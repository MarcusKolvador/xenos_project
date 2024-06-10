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
local weapon_offset_vertical = 15
local weapon_offset_horizontal = 22

-- enemy knockbacks
local goblin_knockback = 30

-- attack settings
local attack_duration = 0.2
local attack_timer = 0

-- draw settings
local sword_equipped_offset_left_x = 10
local sword_equipped_offset_right_x = - 11
local sword_attack_offset_y = - 17
local attacking_model_offset_side = 45

-- misc
local game_end = false

function Update_dodge(dt)

    -- registers the dodge input
    Dodge = love.keyboard.isDown('space')
    -- records the time the dodge button is held
    if Dodge and Player_controls then
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
    if love.mouse.isDown(1) and Player_controls then
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
                for _, goblin_entity in ipairs(Enemies) do
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
    if Player_controls then
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
end

function Attacking_hitbox_handler()
    if Equipped_sword and Attacking then
        if Character == "left" or Character == "right" then
            sword_equipped_entity.hitboxWidth = Sword_equipped_hitbox_y
            sword_equipped_entity.hitboxHeight = Sword_equipped_hitbox_x
            if Character == "left" then
                sword_equipped_entity.x = player_entity.x - weapon_offset_left
                sword_equipped_entity.y = player_entity.y - weapon_offset_vertical
            elseif Character == "right" then
                sword_equipped_entity.x = player_entity.x + weapon_offset_right
                sword_equipped_entity.y = player_entity.y - weapon_offset_vertical
        end
        else
            sword_equipped_entity.hitboxWidth = Sword_equipped_hitbox_x
            sword_equipped_entity.hitboxHeight = Sword_equipped_hitbox_y
            if Character == "front" then
                sword_equipped_entity.y = player_entity.y + weapon_offset_front
                sword_equipped_entity.x = player_entity.x - weapon_offset_horizontal
            elseif Character == "back" then
                sword_equipped_entity.y = player_entity.y + weapon_offset_back
                sword_equipped_entity.x = player_entity.x - weapon_offset_horizontal
            end
        end
    else
        sword_equipped_entity.hitboxHeight = 0
        sword_equipped_entity.hitboxWidth = 0
    end
end

function Pick_up_sword()
    if isColliding(player_entity, sword_entity) and Player_controls then
        Equipped_sword = true
    end
    if Equipped_sword then
        sword_entity.hitboxHeight = 0
        sword_entity.hitboxWidth = 0
    end
end

function Player_touches_goblin()
    for _, goblin_entity in ipairs(Enemies) do
        if isColliding(player_entity, goblin_entity) then
            if Player_controls then
                Character_hurt:play()
            end
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
    -- print(Character)
    local key = Character
    local frame = CurrentFrame
    if Attacking then
        key = "attack_" .. Character
        frame = CurrentAttackFrame
    end
    love.graphics.draw(Spritesheets[key], Frames[key][frame], player_entity.x - Player_hitbox_x - Player_hitbox_offset_x, player_entity.y
    - Player_hitbox_y - Player_hitbox_offset_y, 0, ScaleFactor, ScaleFactor)
end

function Attack_animation()
    if Equipped_sword and Attacking then
        local key = "sword_attack_" .. Character
        print(key)
        -- print(Character)
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

function Player_death()
    if player_entity.health <= 0 and not game_end then
        BackgroundMusic:pause()
        Player_death_sound:play()
        Player_death_sound:setLooping(false)
        Player_controls = false
        game_end = true
    end
end

function Draw_loss()
love.graphics.setColor(1, 0, 0) -- Set color to red
love.graphics.setFont(Font_death)
        local text = "YOU LOSE"
        local text_width = love.graphics.getFont():getWidth(text)
        local text_height = love.graphics.getFont():getHeight(text)
        local x = (love.graphics.getWidth() - text_width) / 2
        local y = (love.graphics.getHeight() - text_height) / 2
        love.graphics.print(text, x, y)
end