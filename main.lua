gr = love.graphics
kb = love.keyboard
ms = love.mouse
screen_w, screen_h = gr.getDimensions()
States = require "States"
function love.load()
    States.load()
end
function love.update(dt)
    States[States.active].update(dt)
end
function love.draw()
    States[States.active].draw()
end
function love.keypressed(key)
    States[States.active].keypressed(key)
end
function love.keyreleased(key)
    States[States.active].keyreleased(key)
end