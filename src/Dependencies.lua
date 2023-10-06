-- a lib push nos permite renderizar o jogo com uma resolução virtual,
-- usando para ter um estética mais retrô
--
-- https://github.com/Ulydev/push
push = require 'lib/push'

-- a lib Class é usada para representar qualquer classe,
-- facilita a organização no código
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

require 'src/constants'
require 'src/classes/Paddle'

-- controle de estados
require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'

require 'src/Util'
