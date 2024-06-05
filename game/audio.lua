function Load_sounds()
    -- Load music
    local backgroundMusic = love.audio.newSource("assets/demon-slayer-8687.mp3", "stream")
    love.audio.play(backgroundMusic)
    backgroundMusic:setLooping(true)
    -- Load sounds
    CutSound = love.audio.newSource("assets/cut_sound.mp3", "static")
    Character_hurt = love.audio.newSource("assets/character_ouch.mp3", "static")
    GoblinHurtSound = love.audio.newSource("assets/goblin_hurt_sound.mp3", "static")
end