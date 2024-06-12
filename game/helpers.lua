local elapsedTime = 0
local FRAME_TIME = 0.2
local ATTACK_FRAME_TIME = 0.05
local elapsedTimeAttack = 0
local elapsedTimeGoblin = 0

function debug()
    love.graphics.rectangle("line", sword_entity.x - FRAME_WIDTH / 2, sword_entity.y - FRAME_HEIGHT / 2, sword_entity.hitboxWidth * ScaleFactor, sword_entity.hitboxHeight * ScaleFactor)
    love.graphics.rectangle("line", sword_equipped_entity.x, sword_equipped_entity.y, sword_equipped_entity.hitboxWidth * ScaleFactor, sword_equipped_entity.hitboxHeight * ScaleFactor)
    for _, goblin_entity in ipairs(Enemies) do
        love.graphics.rectangle("line", goblin_entity.x - FRAME_WIDTH / 2, goblin_entity.y  - FRAME_HEIGHT / 2, Goblin_hitbox_x * ScaleFactor, Goblin_hitbox_y * ScaleFactor)
    end
    love.graphics.rectangle("line", player_entity.x - FRAME_WIDTH / 2, player_entity.y - FRAME_HEIGHT / 2, Player_hitbox_x * ScaleFactor, Player_hitbox_y * ScaleFactor)
    for _, health_entity in ipairs(Drops) do
        love.graphics.rectangle("line", health_entity.x - FRAME_WIDTH / 2, health_entity.y - FRAME_HEIGHT / 2, Sword_hitbox_x * ScaleFactor, Sword_hitbox_y * ScaleFactor)
    end
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
    elseif x <= minX then
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

    if Moving then
        elapsedTime = elapsedTime + dt
        if elapsedTime >= FRAME_TIME then
            elapsedTime = elapsedTime - FRAME_TIME
            CurrentFrame = (CurrentFrame % FRAME_COUNT) + 1
        end
    else
        CurrentFrame = 1
    end

    if Attacking then
        elapsedTimeAttack = elapsedTimeAttack + dt
        if elapsedTimeAttack >= ATTACK_FRAME_TIME then
            elapsedTimeAttack = elapsedTimeAttack - ATTACK_FRAME_TIME
            CurrentAttackFrame = (CurrentAttackFrame % FRAME_COUNT) + 1
        end
    else
        CurrentAttackFrame = 1
    end

    if goblin_entity then
        elapsedTimeGoblin = elapsedTimeGoblin + dt
        if elapsedTimeGoblin >= FRAME_TIME then
            elapsedTimeGoblin = elapsedTimeGoblin - FRAME_TIME
            CurrentGoblinFrame = (CurrentGoblinFrame % FRAME_COUNT) + 1
        end
    else
        CurrentGoblinFrame = 1
    end
end

function Draw_hitboxes()
    -- Draw hitboxes
    if Hitbox_debug == true then
        debug()
    end
end

function FlashRedTimer(dt, entity)
    local interval = 0.3
    FlashTimer = FlashTimer + dt
    if FlashTimer >= interval then
        entity.isDamaged = false
        FlashTimer = 0
    end
end

function SpawnEnemies(dt)
    local timeToDisplay = 2
    if EnemiesSpawned < EnemiesPerWave then
        NewWaveDisplayTimer = NewWaveDisplayTimer + dt
        if NewWaveDisplayTimer < timeToDisplay then
            NewWave = true
        else
            NewWave = false
        end
        GoblinRespawn(dt)
    else
        if #Enemies == 0 then
            NextWave()
            NewWave = true
        end
    end
end

function NextWave()
    EnemiesSpawned = 0
    Wave = Wave + 1
    EnemiesPerWave = Wave * 5
    SpawnInterval = SpawnInterval * 0.9
    NewWaveDisplayTimer = 0
end

function GameEndCountdown(dt)
    if GameEnd then
        DeathTimer = DeathTimer + dt
    end
end

function Draw_wave_no()
    love.graphics.setColor(0.7, 0.7, 0.7) -- Set color to red
    love.graphics.setFont(Font_death)
            local text = "Wave " .. Wave
            local text_width = love.graphics.getFont():getWidth(text)
            local text_height = love.graphics.getFont():getHeight(text)
            local x = (love.graphics.getWidth() - text_width) / 2
            local y = (love.graphics.getHeight() - text_height) / 2
            love.graphics.print(text, x, y)
end

function IsColliding(a, b)
    
    -- Update positions
    local leftA, rightA, topA, bottomA = a.x, a.x + a.hitboxWidth * ScaleFactor, a.y, a.y + a.hitboxHeight * ScaleFactor
    local leftB, rightB, topB, bottomB = b.x, b.x + b.hitboxWidth * ScaleFactor, b.y, b.y + b.hitboxHeight * ScaleFactor

    -- Check for collision
    if rightA > leftB and leftA < rightB and bottomA > topB and topA < bottomB then
        return true
    else
        return false
    end
end

function FlashIfDamaged(dt)
    FlashRedTimer(dt, player_entity)
    if goblin_entity then
        for _, goblin_entity in ipairs(Enemies) do
            FlashRedTimer(dt, goblin_entity)
        end
    end
end
