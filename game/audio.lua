function Load_sounds()
    love.audio.setVolume(0.5)
    -- Load music
    BackgroundMusic = love.audio.newSource("assets/demon-slayer-8687.mp3", "stream")
    love.audio.play(BackgroundMusic)
    BackgroundMusic:setLooping(true)
    -- Load sounds
    CutSound = love.audio.newSource("assets/cut_sound.mp3", "static")
    Character_hurt = love.audio.newSource("assets/character_ouch.mp3", "static")
    GoblinHurtSound = love.audio.newSource("assets/goblin_hurt_sound.mp3", "static")
    Goblin_death_sound = love.audio.newSource("assets/goblin_scream.mp3", "static")
    Player_death_sound = love.audio.newSource("assets/death.mp3", "static")
end