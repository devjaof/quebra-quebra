VictoryState = Class { __includes = BaseState }

function VictoryState:enter(params)
  self.level = params.level
  self.score = params.score
  self.paddle = params.paddle
  self.highScores = params.highScores
  self.health = params.health
  self.ball = params.ball
end

function VictoryState:update(dt)
  self.paddle:update(dt)

  -- gruda a bola no paddle
  self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
  self.ball.y = self.paddle.y - 8

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('serve', {
      level = self.level + 1,
      bricks = LevelMaker.createMap(self.level + 1),
      paddle = self.paddle,
      health = self.health,
      score = self.score,
      highScores = self.highScores
    })
  end

  function VictoryState:render()
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level) .. ' completo!', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Aperte enter para iniciar ', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
  end
end
