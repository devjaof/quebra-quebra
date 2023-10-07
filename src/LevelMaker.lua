LevelMaker = Class {}

--[[
    retorna uma table de tijolo pro main, tem diferentes possibildiades para
    colunas e linhas aleatórias de tijolo.
    calcula a cor e tier dos tijolo de acordo com o level passado.
]]
function LevelMaker.createMap(level)
  local bricks = {}

  -- numero de linhas entre 1 e 5
  local numRows = math.random(1, 5)

  -- numero de colunas entre 7 e 13
  local numCols = math.random(7, 13)

  -- posiciona os tijoolo para que eles se encostem e preencham o espaço
  for y = 1, numRows do
    for x = 1, numCols do
      b = Brick(
        (x - 1)                -- como a tabela é indexada tem que fazer -1
        * 32                   -- 32 é a largura do tijolo
        + 8                    -- a tela tem 8px de padding, então servem 13 colunas + 16px
        + (13 - numCols) * 16, -- padding na esquerda caso tenham menos que 13 colunas

        y * 16                 -- * 16 para o padding top
      )

      table.insert(bricks, b)
    end
  end

  return bricks
end
