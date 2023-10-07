LevelMaker = Class {}

-- estilos de mapa
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

-- cores por linha
SOLID = 1
ALTERNATE = 2
SKIP = 3
NONE = 4

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
  -- garante que seja impar (simetria)
  numCols = numCols % 2 == 0 and (numCols + 1) or numCols

  local highestTier = math.min(3, math.floor(level / 5));

  local highestColor = math.min(5, level % 5 + 3)

  -- posiciona os tijoolo para que eles se encostem e preencham o espaço
  for y = 1, numRows do
    local skipPattern = math.random(1, 2) == 1 and true or false
    local alternatePattern = math.random(1, 2) == 1 and true or false

    local alternateColor1 = math.random(1, highestColor)
    local alternateColor2 = math.random(1, highestColor)
    local alternateTier1 = math.random(0, highestTier)
    local alternateTier2 = math.random(0, highestTier)

    local skipFlag = math.random(2) == 1 and true or false
    local alternateFlag = math.random(2) == 1 and true or false

    local solidColor = math.random(1, highestColor)
    local solidTier = math.random(0, highestTier)

    for x = 1, numCols do
      if skipPattern and skipFlag then
        skipFlag = not skipFlag
        goto continue
      else
        skipFlag = not skipFlag
      end

      b = Brick(
        (x - 1)                -- como a tabela é indexada tem que fazer -1
        * 32                   -- 32 é a largura do tijolo
        + 8                    -- a tela tem 8px de padding, então servem 13 colunas + 16px
        + (13 - numCols) * 16, -- padding na esquerda caso tenham menos que 13 colunas

        y * 16                 -- * 16 para o padding top
      )

      if alternatePattern and alternateFlag then
        b.color = alternateColor1
        b.tier = alternateTier1
        alternateFlag = not alternateFlag
      else
        b.color = alternateColor2
        b.tier = alternateTier2
        alternateFlag = not alternateFlag
      end

      if not alternatePattern then
        b.color = solidColor
        b.tier = solidTier
      end

      table.insert(bricks, b)

      ::continue::
    end
  end

  if #bricks == 0 then
    return self.createMap(level)
  else
    return bricks
  end
end
