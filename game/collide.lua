function isColliding(a, b)
    
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