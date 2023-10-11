HighScoreState = Class { __includes = BaseState }

function HighScoreState:enter(params)
  self.highScores = params.highScores
end

function HighScoreState:update(dt)
  if love.keyboard.wasPressed('escape') then
    gSounds['wall-hit']:play()

    gStateMachine:change('start', {
      highScores = self.highScores
    })
  end
end

function HighScoreState:render()
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('Maiores Pontuacoes', 0, 20, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])

  -- para cada high score (os 10 maiores)
  for i = 1, 10 do
    local name = self.highScores[i].name or '---'
    local score = self.highScores[i].score or '---'

    -- score number (1-10)
    love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4,
      60 + i * 13, 50, 'left')

    -- score name
    love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38,
      60 + i * 13, 50, 'right')

    -- score itself
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2,
      60 + i * 13, 100, 'right')
  end

  love.graphics.setFont(gFonts['small'])
  love.graphics.printf("Aperte esc para voltar ao menu!",
    0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end
