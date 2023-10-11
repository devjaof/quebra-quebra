PaddleSelectState = Class { __includes = BaseState }

function PaddleSelectState:enter(params)
  self.highScores = params.highScores
end

function PaddleSelectState:init()
  self.currentPaddle = 1
end

function PaddleSelectState:update(dt)
  if love.keyboard.wasPressed('left') then
    if self.currentPaddle == 1 then
      gSounds['no-select']:play()
    else
      gSounds['select']:play()
      self.currentPaddle = self.currentPaddle - 1
    end
  end

  if love.keyboard.wasPressed('right') then
    if self.currentPaddle == 4 then
      gSounds['no-select']:play()
    else
      gSounds['select']:play()
      self.currentPaddle = self.currentPaddle + 1
    end
  end

  if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
    gSounds['confirm']:play()

    gStateMachine:change('serve', {
      paddle = Paddle(self.currentPaddle),
      bricks = LevelMaker.createMap(1),
      health = 3,
      score = 0,
      highScores = self.highScores,
      level = 1
    })
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function PaddleSelectState:render()
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf("Selecione tua raquete usando as setas!", 0, VIRTUAL_HEIGHT / 4,
    VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['small'])
  love.graphics.printf("(Aperte enter pra comecar!)", 0, VIRTUAL_HEIGHT / 3,
    VIRTUAL_WIDTH, 'center')

  -- flecha pra esquerda
  if self.currentPaddle == 1 then
    -- se não tiver mais paddle pra esquerda, deixa a flecha cinza
    love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 128 / 255)
  end

  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24,
    VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

  -- reseta a cor
  love.graphics.setColor(1, 1, 1, 1)

  -- flecha pra direita
  if self.currentPaddle == 4 then
    --- se não tiver mais paddle pra direita, deixa a flecha cinza
    love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 128 / 255)
  end

  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
    VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

  -- reseta a cor
  love.graphics.setColor(1, 1, 1, 1)

  -- mostra o paddle em si
  love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.currentPaddle - 1)],
    VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
end
