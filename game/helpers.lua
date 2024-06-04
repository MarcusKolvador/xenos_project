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