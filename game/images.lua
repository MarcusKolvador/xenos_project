local health_sprite_offset_x = 24

function Load_images()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    background = love.graphics.newImage("assets/grass.png")
    Spritesheets = {
        -- Character sprites
        left = love.graphics.newImage("assets/avatar_left.png"),
        right = love.graphics.newImage("assets/avatar_right.png"),
        back = love.graphics.newImage("assets/avatar_back.png"),
        front = love.graphics.newImage("assets/avatar_front.png"),
        attack_front = love.graphics.newImage("assets/character_attack_front.png"),
        attack_back = love.graphics.newImage("assets/character_attack_back.png"),
        attack_left = love.graphics.newImage("assets/character_attack_left.png"),
        attack_right = love.graphics.newImage("assets/character_attack_right.png"),
        -- Character status effects
        dodge_ui = love.graphics.newImage("assets/dodge.png"),
        -- Weapon equipped sprites
        sword_equipped = love.graphics.newImage("assets/sword_equipped.png"),
        sword_equipped_right = love.graphics.newImage("assets/sword_equipped_right.png"),
        -- Weapon attack sprites
        sword_attack_left = love.graphics.newImage("assets/sword_left.png"),
        sword_attack_right = love.graphics.newImage("assets/sword_right.png"),
        sword_attack_back = love.graphics.newImage("assets/sword_back.png"),
        sword_attack_front = love.graphics.newImage("assets/sword_front.png"),
        -- Goblin move sprites
        goblin_left = love.graphics.newImage("assets/goblin_left.png"),
        goblin_right = love.graphics.newImage("assets/goblin_right.png"),
        goblin_back = love.graphics.newImage("assets/goblin_back.png"),
        goblin_front = love.graphics.newImage("assets/goblin_front.png"),
    }
    -- Item sprites
    sword_sprite = love.graphics.newImage("assets/sword.png")
    -- Enemies
    goblin_sprite = love.graphics.newImage("assets/goblin.png")
    -- Character Sprite
    character_sprite = love.graphics.newImage("assets/avatar.png")
    -- Health drop Sprite
    health_sprite = love.graphics.newImage("assets/health_sprite.png")
    -- Fonts
    Font = love.graphics.newFont("assets/Lobster-Regular.ttf", 22)
    Font_death = love.graphics.newFont("assets/Lobster-Regular.ttf", 64)
    -- Read Frames from sprites, assuming they're placed horizontally, at 4 Frames
    for sprite, spritesheet in pairs(Spritesheets) do
        Frames[sprite] = {}
        for i = 0, FRAME_COUNT - 1 do
            table.insert(Frames[sprite], love.graphics.newQuad(i * FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT, spritesheet:getDimensions()))
        end
    end
end