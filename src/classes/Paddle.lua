Paddle = Class {}

function Paddle:init()
    -- o x inicia no meio da tela
    self.x = VIRTUAL_WIDTH / 2 - 32

    -- o y inicia um pouco pra cima da parte inferior
    self.y = VIRTUAL_HEIGHT - 32

    -- inicia com velocidade 0
    self.dx = 0

    -- dimenções iniciais
    self.width = 64
    self.height = 16

    -- a cor do paddle
    self.skin = 1

    -- a tamanho do paddle inicial, poderá ser alterado posteriormente
    self.size = 2
end

function Paddle:update(dt)
    -- teclado
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    -- self.dx negativo => indo para a esquerda
    -- self.dx positivo => indo para a direita
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

-- renderiza o quad específico do paddle
function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
        self.x, self.y)
end
