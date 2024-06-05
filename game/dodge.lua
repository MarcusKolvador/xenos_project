local dodge_button_timer = 0
local dodge_length = 0.1
local dodge_cooldown = 0
local dodge_cooldown_period = 5

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