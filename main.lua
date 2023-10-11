require 'src/Dependencies'

function love.load()
    -- o filtro "nearest-neighbor", vai fazer com que os pixels não sejam borrados
    -- vai dar um ar mais 2d e pixelado
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seeda o gerador de números aleatórios para que as calls
    -- random realmente sejam random
    math.randomseed(os.time())

    love.window.setTitle('Quebra-quebra')

    -- inicialização das fontes
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    -- carrega os assets em uma table global
    gTextures = {
        ['background'] = love.graphics.newImage('assets/background.png'),
        ['main'] = love.graphics.newImage('assets/breakout.png'),
        ['arrows'] = love.graphics.newImage('assets/arrows.png'),
        ['hearts'] = love.graphics.newImage('assets/hearts.png'),
        ['particle'] = love.graphics.newImage('assets/particle.png')
    }

    -- os quads que são gerados através de sprite sheets
    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
    }

    -- inicialização do push com a resolução virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- carrega os sons em uma table global
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }


    -- gerenciamento de states:

    -- 1. 'start' - o começo do jogo, onde pede para apertar enter
    -- 2. 'paddle-select' - seleção de cor para o player
    -- 3. 'serve' - em espera para jogar a bola
    -- 4. 'play' - jogando
    -- 5. 'victory' - tela de vitória
    -- 6. 'game-over' - fim de jogo, mostra os scores e pode reiniciar o jogo
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['game-over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['high-scores'] = function() return HighScoreState() end,
    }
    gStateMachine:change('start', {
        highScores = loadHighScores()
    })

    -- table usava para saber qual tecla foi apertada, já que o love2d não tem essa função
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)

    -- reseta os keypressed a cada update
    love.keyboard.keysPressed = {}
end

-- callback para lidar com a table keysPressed,
-- não funciona para teclas que permanecem apertadas, outra função lida com isso
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

-- esta função é custom, usada para validar se uma tecla foi apertada,
-- isso fora da função default love.keypressed. já que essa lógica não pode
-- ser chamada por default em outros lugares
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

-- é chamada a cada frame após o update, responsável por
-- desenhar na tela tudo que a gente quiser ;)
function love.draw()
    push:apply('start')

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'],
        -- desenha nas coordenadas x 0, y 0
        0, 0,
        -- sem rotação
        0,
        -- a escala do background deve preencher a tela toda de acordo com a virtual res
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    -- state machine para renderizar o estado atual
    gStateMachine:render()

    displayFPS()

    push:apply('end')
end

function renderHealth(health)
    local healthX = VIRTUAL_WIDTH - 100

    -- renderiza o que tem de vida
    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- renderiza o que ta faltando
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

-- Carrega os high sore de um arquivo .lst
function loadHighScores()
    love.filesystem.setIdentity('quebra-quebra_scores')

    -- valores default caso o arquivo nao exista
    if not love.filesystem.getInfo('quebra-quebra_scores.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. '---\n'
            scores = scores .. '---\n'
        end

        love.filesystem.write('quebra-quebra_scores.lst', scores)
    end

    local readingName = true
    local currentName = nil
    local counter = 1

    -- inicializa uma tabela de score vazia
    local scores = {}
    for i = 1, 10 do
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iteração no arquivo de save pegando os nomes e scores
    for line in love.filesystem.lines('quebra-quebra_scores.lst') do
        if readingName then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        readingName = not readingName
    end

    return scores
end
