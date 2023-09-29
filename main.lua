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
        ['start'] = function() return StartState() end
    }
    gStateMachine:change('start')

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


function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end