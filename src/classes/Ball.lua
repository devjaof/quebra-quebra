Ball = Class {}

function Ball:init(skin)
  self.width = 8
  self.height = 8

  -- velocidade da bolota
  self.dy = 0
  self.dx = 0

  -- cor da bolota
  self.skin = skin
end

--[[
    Recebe uma prop que é uma "bounding box", pode ser um paddle ou um tijolo
]]
function Ball:collides(target)
  -- checa a colisão na horizontal
  if self.x > target.x + target.width or target.x > self.x + self.width then
    return false
  end

  -- checa a colisão na vertical
  if self.y > target.y + target.height or target.y > self.y + self.height then
    return false
  end

  return true
end

--[[
    a bola começa no mei da tela
]]
function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2
  self.dx = 0
  self.dy = 0
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  -- a bola vai rebater nas parede
  if self.x <= 0 then
    self.x = 0
    self.dx = -self.dx
    gSounds['wall-hit']:play()
  end

  if self.x >= VIRTUAL_WIDTH - 8 then
    self.x = VIRTUAL_WIDTH - 8
    self.dx = -self.dx
    gSounds['wall-hit']:play()
  end

  if self.y <= 0 then
    self.y = 0
    self.dy = -self.dy
    gSounds['wall-hit']:play()
  end
end

function Ball:render()
  love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin],
    self.x, self.y)
end
