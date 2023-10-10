PlayState = Class { __includes = BaseState }

function PlayState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.score = params.score
  self.ball = params.ball
  self.level = params.level

  -- a bola começa numa velocidade aleatória nunca se sabe
  self.ball.dx = math.random(-200, 200)
  self.ball.dy = math.random(-50, -60)
end

function PlayState:update(dt)
  if self.paused then
    if love.keyboard.wasPressed('space') then
      self.paused = false
      gSounds['pause']:play()
    else
      return
    end
  elseif love.keyboard.wasPressed('space') then
    self.paused = true
    gSounds['pause']:play()
    return
  end

  self.paddle:update(dt)
  self.ball:update(dt)

  if self.ball:collides(self.paddle) then
    -- coloca a bola pra cima do paddle caso de o bug de ficar presa
    self.ball.y = self.paddle.y - 8
    self.ball.dy = -self.ball.dy

    -- se a bola bater no lado esquerdo do paddle enquando nos movemos para a esquerda
    if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
      self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

      -- mesma coisa só que pra direita
    elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
      self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
    end



    gSounds['paddle-hit']:play()
  end

  -- colisão nos tijolo
  for k, brick in pairs(self.bricks) do
    if brick.inPlay and self.ball:collides(brick) then
      self.score = self.score + (brick.tier * 200 + brick.color * 25)

      brick:hit()

      if self:checkVictory() then
        gSounds['victory']:play()

        gStateMachine:change('victory', {
          level = self.level,
          paddle = self.paddle,
          health = self.health,
          score = self.score,
          ball = self.ball
        })
      end

      -- lado esquerdo, só checa se a bola está se movendo para a direita
      if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
        -- alterna velocidade de x e reseta a posição da bola fora do tijolo
        self.ball.dx = -self.ball.dx
        self.ball.x = brick.x - 8

        -- lado direito
      elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
        self.ball.dx = -self.ball.dx
        self.ball.x = brick.x + 32

        -- em cima
      elseif self.ball.y < brick.y then
        -- alterna a velocidade de y e reseta a posição da bolota fora do tijolo
        self.ball.dy = -self.ball.dy
        self.ball.y = brick.y - 8

        -- embaixo né
      else
        self.ball.dy = -self.ball.dy
        self.ball.y = brick.y + 16
      end

      -- acelerar o game né papai
      self.ball.dy = self.ball.dy * 1.02

      break
    end
  end

  if self.ball.y >= VIRTUAL_HEIGHT then
    self.health = self.health - 1
    gSounds['hurt']:play()

    if (self.health == 0) then
      gStateMachine:change('game-over', {
        score = self.score
      })
    else
      gStateMachine:change('serve', {
        paddle = self.paddle,
        bricks = self.bricks,
        health = self.health,
        score = self.score
      })
    end
  end

  for k, brick in pairs(self.bricks) do
      brick:update(dt)
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function PlayState:render()
  -- renderiza os tijolo
  for k, brick in pairs(self.bricks) do
    brick:render()
  end

  -- renderiza as particulas
  for k, brick in pairs(self.bricks) do
    brick:renderParticles()
  end

  self.paddle:render()
  self.ball:render()

  renderScore(self.score)
  renderHealth(self.health)

  if self.paused then
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Pausou o joguinho eh?", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
  end
end

function PlayState:checkVictory()
  for k, brick in pairs(self.bricks) do
    if (brick.inPlay) then
      return false
    end
  end

  return true
end
