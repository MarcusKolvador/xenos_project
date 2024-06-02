dodge_button_timer = 0
dodge_button_released = true
dodge_length = 0.1
dodge_cooldown = 0
dodge_cooldown_period = 5

function updateDodge(dt)
    -- records the time the dodge button is held
    if Dodge then
        dodge_button_timer = dodge_button_timer + dt
        dodge_button_released = false
    else
        -- resets the ticker if dodge button released
        dodge_cooldown = math.max(0, dodge_cooldown - dt)
        if dodge_cooldown == 0 and not dodge_button_released then
            dodge_button_timer = 0
            dodge_cooldown = dodge_cooldown_period
            dodge_button_released = trueF
        end
    end

    -- checks if dodge button was held longer than allowed and sets the dodge cooldown to false or true
    if dodge_button_timer > dodge_length then
        Dodge_up = false
    else
        Dodge_up = true
    end
end