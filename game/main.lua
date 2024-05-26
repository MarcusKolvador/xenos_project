-- Constants
local FRAME_WIDTH = 32
local FRAME_HEIGHT = 32
local FRAME_COUNT = 4
local MOVE_SPEED = {normal = 150, dodge = 550}
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
        front = love.graphics.newImage("assets/avatar_front.png")
    }
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
    local moveSpeed = moving and (dodge and MOVE_SPEED.dodge or MOVE_SPEED.normal) or 0

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

    dodge = love.keyboard.isDown('space')

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
end

-- Handle window resizing
function love.resize(w, h)
    updateMapSize()
end

-- Update map size based on window dimensions
function updateMapSize()
    mapWidth, mapHeight = love.graphics.getWidth(), love.graphics.getHeight()
end
