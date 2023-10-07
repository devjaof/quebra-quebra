Brick = Class {}

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
end

function Brick:hit()
  gSounds['brick-hit-2']:play()

  self.inPlay = false
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
