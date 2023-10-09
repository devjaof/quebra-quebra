Brick = Class {}

paletteColors = {
  -- azul
  [1] = {
    ['r'] = 99,
    ['g'] = 155,
    ['b'] = 255
  },
  -- verde
  [2] = {
    ['r'] = 106,
    ['g'] = 190,
    ['b'] = 47
  },
  -- vermei
  [3] = {
    ['r'] = 217,
    ['g'] = 87,
    ['b'] = 99
  },
  -- roxo
  [4] = {
    ['r'] = 215,
    ['g'] = 123,
    ['b'] = 186
  },
  -- dorado
  [5] = {
    ['r'] = 251,
    ['g'] = 242,
    ['b'] = 54
  }
}

function Brick:init(x, y)
  -- pontuação e cor
  self.tier = 0
  self.color = 1

  self.x = x
  self.y = y
  self.width = 32
  self.height = 16

  -- se é true então renderiza
  self.inPlay = true

  -- particle system
  -- https://love2d.org/wiki/ParticleSystem
  self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

  self.psystem:setParticleLifetime(0.5, 1)
  self.psystem:setLinearAcceleration(-15, 0, 15, 80)
  self.psystem:setEmissionArea('normal', 10, 10)
end

function Brick:hit()
  gSounds['brick-hit-2']:stop()
  gSounds['brick-hit-2']:play()

  self.psystem:setColors(
    paletteColors[self.color].r / 255,
    paletteColors[self.color].g / 255,
    paletteColors[self.color].b / 255,
    55 * (self.tier + 1) / 255,
    paletteColors[self.color].r / 255,
    paletteColors[self.color].g / 255,
    paletteColors[self.color].b / 255,
    0
  )
  self.psystem:emit(64)

  if self.tier > 0 then
    if self.color == 1 then
      self.tier = self.tier - 1
      self.color = 5
    else
      self.color = self.color - 1
    end
  else
    if self.color == 1 then
      self.inPlay = false
    else
      self.color = self.color - 1
    end
  end

  if not self.inPlay then
    gSounds['brick-hit-1']:stop()
    gSounds['brick-hit-1']:play()
  end
end

function Brick:update(dt)
  self.psystem:update(dt)
end

function Brick:render()
  if self.inPlay then
    love.graphics.draw(gTextures['main'],
      -- multiplica a cor por 4 (-1) para pegar a cor offset
      -- e passa o tier para pegar o bloco certo
      gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
      self.x, self.y)
  end
end

function Brick:renderParticles()
  love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end
