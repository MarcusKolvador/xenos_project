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

function Boundary_handler()
    local minX, minY = 0, 0
    local maxX, maxY = love.graphics.getWidth(), love.graphics.getHeight()
    local newBoing = love.audio.newSource("assets/boing.mp3", "static")
    player_entity.x = math.max(minX, math.min(maxX, player_entity.x))
    player_entity.y = math.max(minY, math.min(maxY, player_entity.y))
    if player_entity.x >= maxX then
        newBoing:play()
        player_entity.x = maxX - 20
    elseif player_entity.x <= minX then
        newBoing:play()
        player_entity.x = minX + 20
    end
    if player_entity.y >= maxY then
        newBoing:play()
        player_entity.y = maxY - 20
    elseif player_entity.y <= minY then
        newBoing:play()
        player_entity.y = minY + 20
    end
end