--[[
    Dado um "atlas" com diversas sprites, assim como um width e height para os tiles.
    Quebra a textura em tiles.
]]
function GenerateQuads(atlas, tilewidth, tileheight)
  local sheetWidth = atlas:getWidth() / tilewidth
  local sheetHeight = atlas:getHeight() / tileheight

  local sheetCounter = 1
  local spritesheet = {}

  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      spritesheet[sheetCounter] =
          love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
            tileheight, atlas:getDimensions())
      sheetCounter = sheetCounter + 1
    end
  end

  return spritesheet
end

--[[
  slice a la python
  https://stackoverflow.com/questions/24821045/does-lua-have-something-like-pythons-slice
]]
function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced + 1] = tbl[i]
  end

  return sliced
end

--[[
  Esta função serve para "destacar" os quad paddle do sprite sheet.
  Já que os paddle tem diferentes tamanho, deve-se destaca-las manualment.
]]
function GenerateQuadsPaddles(atlas)
  --  posição na spritesheet onde os paddle estão
  local x = 0
  local y = 64

  local counter = 1
  local quads = {}


  for i = 0, 3 do
    -- pequeno
    quads[counter] = love.graphics.newQuad(x, y, 32, 16,
      atlas:getDimensions())
    counter = counter + 1
    -- medio
    quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16,
      atlas:getDimensions())
    counter = counter + 1
    -- grande
    quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16,
      atlas:getDimensions())
    counter = counter + 1
    -- enorme
    quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16,
      atlas:getDimensions())
    counter = counter + 1

    -- já deixa o x e y preparados para o proximo paddle
    x = 0
    y = y + 32
  end

  return quads
end

--[[
  Esta função serve para "destacar" as bola do sprite sheet.
]]
function GenerateQuadsBalls(atlas)
  local x = 96
  local y = 48

  local counter = 1
  local quads = {}

  for i = 0, 3 do
    quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
    x = x + 8
    counter = counter + 1
  end

  x = 96
  y = 56

  for i = 0, 2 do
    quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
    x = x + 8
    counter = counter + 1
  end

  return quads
end

--[[
  Esta função serve para "destacar" os tijolo do sprite sheet.
]]
function GenerateQuadsBricks(atlas)
  return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
end
