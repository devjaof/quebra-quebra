GameOverState = Class { __includes = BaseState }

function GameOverState:enter(params)
  self.score = params.score
  self.highScores = params.highScores
end

function GameOverState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- primeiro é preciso checar se o score é maior que algum score da tabela
    local isHighScore = false

    for i = 10, 1, -1 do
      local score = self.highScores[i].score or 0

      if self.score > score then
        highScoreIndex = i
        isHighScore = true
      end
    end

    if isHighScore then
      gSounds['high-score']:play()
      gStateMachine:change('enter-high-scores', {
        highScores = self.highScores,
        score = self.score,
        scoreIndex = highScoreIndex
      })
    else
      gStateMachine:change('start', {
        highScores = self.highScores
      })
    end
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function GameOverState:render()
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
    VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,
    VIRTUAL_WIDTH, 'center')
end
