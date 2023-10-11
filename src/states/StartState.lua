StartState = Class { __includes = BaseState }

-- o highlight da seleção do Iniciar ou pontuações
local highlighted = 1

function StartState:enter(params)
  self.highScores = params.highScores
end

function StartState:update(dt)
  -- alteração entre as seleções no menu
  if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
    highlighted = highlighted == 1 and 2 or 1
    gSounds['paddle-hit']:play()
  end

  -- confirma a seleção no menu
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gSounds['confirm']:play()

    if highlighted == 1 then
      gStateMachine:change('serve', {
        paddle = Paddle(1),
        bricks = LevelMaker.createMap(1),
        health = 3,
        score = 0,
        level = 1
      })
    else
      gStateMachine:change('high-scores', {
        highScores = self.highScores
      })
    end
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function StartState:render()
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf("QUEBRA-QUEBRA", 0, VIRTUAL_HEIGHT / 3,
    VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])

  -- renderiza a cor do highlight na opção selecionada
  if highlighted == 1 then
    love.graphics.setColor(103 / 255, 1, 1, 1)
  end
  love.graphics.printf("INICIAR", 0, VIRTUAL_HEIGHT / 2 + 70,
    VIRTUAL_WIDTH, 'center')

  love.graphics.setColor(1, 1, 1, 1)

  if highlighted == 2 then
    love.graphics.setColor(103 / 255, 1, 1, 1)
  end
  love.graphics.printf("MAIORES PONTUACOES", 0, VIRTUAL_HEIGHT / 2 + 90,
    VIRTUAL_WIDTH, 'center')

  love.graphics.setColor(1, 1, 1, 1)
end
