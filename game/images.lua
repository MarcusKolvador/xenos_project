function Load_images()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    background = love.graphics.newImage("assets/grass.png")
    Spritesheets = {
        -- Character sprites
        left = love.graphics.newImage("assets/avatar_left.png"),
        right = love.graphics.newImage("assets/avatar_right.png"),
        back = love.graphics.newImage("assets/avatar_back.png"),
        front = love.graphics.newImage("assets/avatar_front.png"),
        -- Character status effects
        dodge_ui = love.graphics.newImage("assets/dodge.png"),
        -- Weapon equipped sprites
        sword_equipped = love.graphics.newImage("assets/sword_equipped.png"),
        sword_equipped_right = love.graphics.newImage("assets/sword_equipped_right.png"),
        -- Weapon attack sprites
        sword_attack_left = love.graphics.newImage("assets/attack_left.png"),
        sword_attack_right = love.graphics.newImage("assets/attack_right.png"),
        sword_attack_back = love.graphics.newImage("assets/attack_back.png"),
        sword_attack_front = love.graphics.newImage("assets/attack_front.png"),
    }
    -- Item sprites
    sword_sprite = love.graphics.newImage("assets/sword.png")
    -- Enemies
    goblin_sprite = love.graphics.newImage("assets/goblin.png")
    -- Read Frames from sprites, assuming they're placed horizontally, at 4 Frames
    for sprite, spritesheet in pairs(Spritesheets) do
        Frames[sprite] = {}
        for i = 0, FRAME_COUNT - 1 do
            table.insert(Frames[sprite], love.graphics.newQuad(i * FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT, spritesheet:getDimensions()))
        end
    end
end

function Draw_background()
    for bg_y = 0, love.graphics.getHeight() / (background:getHeight() * ScaleFactor) do
        for bg_x = 0, love.graphics.getWidth() / (background:getWidth() * ScaleFactor) do
            love.graphics.draw(background, bg_x * background:getWidth() * ScaleFactor, bg_y * background:getHeight() * ScaleFactor, 0, ScaleFactor)
        end
    end
end

function Draw_sword()
    if not Equipped_sword then
        love.graphics.draw(sword_sprite, sword_entity.x - Sword_hitbox_x, sword_entity.y - Sword_hitbox_y, 0, ScaleFactor / 2, ScaleFactor / 2)
    end
end