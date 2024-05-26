-- Constants
local FRAME_WIDTH = 32
local FRAME_HEIGHT = 32
local FRAME_COUNT = 4
local MOVE_SPEED = {normal = 150, dodge = 700}
local FRAME_TIME = 0.25

-- Variables
local backgroundMusic
local background
local spritesheets = {}
local frames = {}
local currentFrame = 1
local elapsedTime = 0
local x, y
local mapWidth, mapHeight
local moving = false
local dodge = false
local scaleFactor = 3
local character = "front"
local dodge_time = 0.1
local dodge_ticker = 0
local dodge_cooldown = 0
local equipped_sword = true

-- Load assets and initialize
function love.load()
    -- Load music
    backgroundMusic = love.audio.newSource("assets/demon-slayer-8687.mp3", "stream")
    love.audio.play(backgroundMusic)
    backgroundMusic:setLooping(true)

    -- Load images
    love.graphics.setDefaultFilter('nearest', 'nearest')
    background = love.graphics.newImage("assets/grass.png")
    spritesheets = {
        left = love.graphics.newImage("assets/avatar_left.png"),
        right = love.graphics.newImage("assets/avatar_right.png"),
        back = love.graphics.newImage("assets/avatar_back.png"),
        front = love.graphics.newImage("assets/avatar_front.png"),
        dodge_ui = love.graphics.newImage("assets/dodge.png"),
        sword_equipped = love.graphics.newImage("assets/sword_equipped.png"),
        sword_equipped_right = love.graphics.newImage("assets/sword_equipped_right.png"),
    }
    sword = love.graphics.newImage("assets/sword.png")
    


    for direction, spritesheet in pairs(spritesheets) do
        frames[direction] = {}
        for i = 0, FRAME_COUNT - 1 do
            table.insert(frames[direction], love.graphics.newQuad(i * FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT, spritesheet:getDimensions()))
        end
    end

    -- Initialize player position
    updateMapSize()
    x, y = mapWidth / 2, mapHeight / 2
end

-- Update game state
function love.update(dt)
    local moveSpeed = moving and (dodge and dodge_up and MOVE_SPEED.dodge or MOVE_SPEED.normal) or 0
    moving = false

    -- Player movement logic
    if love.keyboard.isDown('s') then
        character = "front"
        y = y + moveSpeed * dt
        moving = true
    elseif love.keyboard.isDown('w') then
        character = "back"
        y = y - moveSpeed * dt
        moving = true
    end

    if love.keyboard.isDown('a') then
        character = "left"
        x = x - moveSpeed * dt
        moving = true
    elseif love.keyboard.isDown('d') then
        character = "right"
        x = x + moveSpeed * dt
        moving = true
    end

    -- dodge input
    dodge = love.keyboard.isDown('space')
    
    -- records the time the dodge button is held
    if dodge then
        dodge_ticker = dodge_ticker + dt
        dodge_released = false
    else
    -- resets the ticker if dodge button released
        dodge_cooldown = math.max(0, dodge_cooldown - dt)
        if dodge_cooldown == 0 and not dodge_released then
            dodge_ticker = 0
            dodge_cooldown = 5
            dodge_released = true
        end
    end

    -- cheecks if dodge button was held longer than allowed and sets the dodge cooldown to false or ture
    if dodge_ticker > dodge_time then
        dodge_up = false
    else
        dodge_up = true
    end

    -- Constrain player within map boundaries
    x = math.max(0, math.min(x, mapWidth - FRAME_WIDTH * scaleFactor))
    y = math.max(0, math.min(y, mapHeight - FRAME_HEIGHT * scaleFactor))

    -- Update animation
    if moving then
        elapsedTime = elapsedTime + dt
        if elapsedTime >= FRAME_TIME then
            elapsedTime = elapsedTime - FRAME_TIME
            currentFrame = (currentFrame % FRAME_COUNT) + 1
        end
    else
        currentFrame = 1
    end
end

-- Render the game
function love.draw()
    -- Draw background
    for y = 0, love.graphics.getHeight() / (background:getHeight() * scaleFactor) do
        for x = 0, love.graphics.getWidth() / (background:getWidth() * scaleFactor) do
            love.graphics.draw(background, x * background:getWidth() * scaleFactor, y * background:getHeight() * scaleFactor, 0, scaleFactor)
        end
    end

    -- Draw player
    love.graphics.draw(spritesheets[character], frames[character][currentFrame], x, y, 0, scaleFactor, scaleFactor)

    -- Spawn sword
    love.graphics.draw(sword, 100, 360, 0, scaleFactor * 0.5, scaleFactor * 0.5)

    -- Draw sword
    if equipped_sword == true then
        if character ~= "right" then
            love.graphics.draw(spritesheets["sword_equipped"], frames["sword_equipped"][currentFrame], x, y, 0, scaleFactor, scaleFactor)
        else
            love.graphics.draw(spritesheets["sword_equipped_right"], frames["sword_equipped_right"][currentFrame], x, y, 0, scaleFactor, scaleFactor)
        end
    end

    -- Draw UI
    if dodge_up == false then
        love.graphics.draw(spritesheets["dodge_ui"], frames["dodge_ui"][currentFrame], x, y, 0, scaleFactor, scaleFactor)
    end

    
end

-- Handle window resizing
function love.resize(w, h)
    updateMapSize()
end

-- Update map size based on window dimensions
function updateMapSize()
    mapWidth, mapHeight = love.graphics.getWidth(), love.graphics.getHeight()
end
