function Load_images()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    background = love.graphics.newImage("assets/grass.png")
    spritesheets = {
        -- Character sprites
        left = love.graphics.newImage("assets/avatar_left.png"),
        right = love.graphics.newImage("assets/avatar_right.png"),
        back = love.graphics.newImage("assets/avatar_back.png"),
        front = love.graphics.newImage("assets/avatar_front.png"),
        -- Character attacks
        attack_front = love.graphics.newImage("assets/attack_front.png"),
        -- Character status effects
        dodge_ui = love.graphics.newImage("assets/dodge.png"),
        -- Weapon equipped sprites
        sword_equipped = love.graphics.newImage("assets/sword_equipped.png"),
        sword_equipped_right = love.graphics.newImage("assets/sword_equipped_right.png"),
    }
    -- Item sprites
    sword_sprite = love.graphics.newImage("assets/sword.png")
    -- Enemies
    goblin_sprite = love.graphics.newImage("assets/goblin.png")
    -- Read frames from sprites, assuming they're placed horizontally, at 4 frames
    for sprite, spritesheet in pairs(spritesheets) do
        frames[sprite] = {}
        for i = 0, FRAME_COUNT - 1 do
            table.insert(frames[sprite], love.graphics.newQuad(i * FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT, spritesheet:getDimensions()))
        end
    end
end