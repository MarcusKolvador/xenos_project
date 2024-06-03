function debug()
    if not Equipped_sword then
        love.graphics.rectangle("line", sword_entity.x - FRAME_WIDTH / 2, sword_entity.y - FRAME_HEIGHT / 2, Sword_hitbox_x * ScaleFactor, Sword_hitbox_y * ScaleFactor)
    end
    love.graphics.rectangle("line", goblin_entity.x - FRAME_WIDTH / 2, goblin_entity.y  - FRAME_HEIGHT / 2, Goblin_hitbox_x * ScaleFactor, Goblin_hitbox_y * ScaleFactor)
    love.graphics.rectangle("line", player_entity.x - FRAME_WIDTH / 2, player_entity.y - FRAME_HEIGHT / 2, Player_hitbox_x * ScaleFactor, Player_hitbox_y * ScaleFactor)
end

function love.keypressed(key)
    if key == "k" then
        Hitbox_debug = not Hitbox_debug
    end
end