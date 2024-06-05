local elapsedTime = 0
local FRAME_TIME = 0.25
local ATTACK_FRAME_TIME = 0.05
local elapsedTimeAttack = 0

function debug()
    love.graphics.rectangle("line", sword_entity.x - FRAME_WIDTH / 2, sword_entity.y - FRAME_HEIGHT / 2, sword_entity.hitboxWidth * ScaleFactor, sword_entity.hitboxHeight * ScaleFactor)
    love.graphics.rectangle("line", sword_equipped_entity.x, sword_equipped_entity.y, sword_equipped_entity.hitboxWidth * ScaleFactor, sword_equipped_entity.hitboxHeight * ScaleFactor)
    love.graphics.rectangle("line", goblin_entity.x - FRAME_WIDTH / 2, goblin_entity.y  - FRAME_HEIGHT / 2, Goblin_hitbox_x * ScaleFactor, Goblin_hitbox_y * ScaleFactor)
    love.graphics.rectangle("line", player_entity.x - FRAME_WIDTH / 2, player_entity.y - FRAME_HEIGHT / 2, Player_hitbox_x * ScaleFactor, Player_hitbox_y * ScaleFactor)
end

function love.keypressed(key)
    if key == "k" then
        Hitbox_debug = not Hitbox_debug
    end
end

function Boundary_handler(x, y)
    local minX, minY = 0, 0
    local maxX, maxY = love.graphics.getWidth(), love.graphics.getHeight()
    local newBoing = love.audio.newSource("assets/boing.mp3", "static")
    x = math.max(minX, math.min(maxX, x))
    y = math.max(minY, math.min(maxY, y))
    if x >= maxX then
        newBoing:play()
        x = maxX - 20
    elseif player_entity.x <= minX then
        newBoing:play()
        x = minX + 20
    end
    if y >= maxY then
        newBoing:play()
        y = maxY - 20
    elseif y <= minY then
        newBoing:play()
        y = minY + 20
    end
    return x, y
end

function Animation_updater(dt)
    ---
    if Moving then
        elapsedTime = elapsedTime + dt
        if elapsedTime >= FRAME_TIME then
            elapsedTime = elapsedTime - FRAME_TIME
            CurrentFrame = (CurrentFrame % FRAME_COUNT) + 1
        end
    else
        CurrentFrame = 1
    end
    ---
    if Attacking then
        elapsedTimeAttack = elapsedTimeAttack + dt
        if elapsedTimeAttack >= ATTACK_FRAME_TIME then
            elapsedTimeAttack = elapsedTimeAttack - ATTACK_FRAME_TIME
            CurrentAttackFrame = (CurrentAttackFrame % FRAME_COUNT) + 1
        end
    else
        CurrentAttackFrame = 1
    end
end

function Draw_hitboxes()
    -- Draw hitboxes
    if Hitbox_debug == true then
        debug()
    end
end