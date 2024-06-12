local elapsedTime = 0
local FRAME_TIME = 0.2
local ATTACK_FRAME_TIME = 0.05
local elapsedTimeAttack = 0
local elapsedTimeGoblin = 0

-- Hitboxes
function love.keypressed(key)
    if key == "k" then
        Hitbox_debug = not Hitbox_debug
    end
end

function DrawHitboxes()
    if Hitbox_debug then
        DrawEntityHitbox(sword_entity)
        DrawEntityHitbox(sword_equipped_entity)
        for _, goblin_entity in ipairs(Enemies) do
            DrawEntityHitbox(goblin_entity)
        end
        DrawEntityHitbox(player_entity)
        for _, health_entity in ipairs(Drops) do
            DrawEntityHitbox(health_entity)
        end
    end
end

function DrawEntityHitbox(entity)
    love.graphics.rectangle("line", entity.x - FRAME_WIDTH / 2, entity.y - FRAME_HEIGHT / 2, entity.hitboxWidth * ScaleFactor, entity.hitboxHeight * ScaleFactor)
end

-- Misc logic

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

function FlashIfDamaged(dt)
    FlashRedTimer(dt, player_entity)
    if goblin_entity then
        for _, goblin_entity in ipairs(Enemies) do
            FlashRedTimer(dt, goblin_entity)
        end
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

-- Draw

function Draw_sword()
    if not Equipped_sword then
        love.graphics.draw(sword_sprite, sword_entity.x - FRAME_WIDTH / 2, sword_entity.y - FRAME_WIDTH / 2, 0, ScaleFactor / 2, ScaleFactor / 2)
    end
end

function Draw_health()
    for _, health_entity in ipairs(Drops) do
        love.graphics.draw(health_sprite, health_entity.x - FRAME_WIDTH / 2 - health_sprite_offset_x, health_entity.y - FRAME_HEIGHT / 2, 0, ScaleFactor, ScaleFactor)
    end
end

function Draw_background()
    for bg_y = 0, love.graphics.getHeight() / (background:getHeight() * ScaleFactor) do
        for bg_x = 0, love.graphics.getWidth() / (background:getWidth() * ScaleFactor) do
            love.graphics.draw(background, bg_x * background:getWidth() * ScaleFactor, bg_y * background:getHeight() * ScaleFactor, 0, ScaleFactor)
        end
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
