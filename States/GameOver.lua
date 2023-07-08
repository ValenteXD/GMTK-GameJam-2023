local GameOver = {}
local bigFont,smallFont
function GameOver.load(info)
    bigFont=gr.newFont(30)
    smallFont=gr.newFont(20)
    
end

function GameOver.update(dt)

end

function GameOver.draw()
    gr.setBackgroundColor(0,0,0)
    gr.setColor(0.7,0,0)
    gr.setFont(bigFont)
    gr.printf('GameOver',0,screen_h/2,screen_w,'center')
    gr.setColor(0.7,0.7,0.7)
    gr.setFont(smallFont)
    gr.printf('Press any key',0,screen_h/2+50,screen_w,'center')
end

function GameOver.keypressed(key)
    States.change('title')
end
function GameOver.keyreleased(key)
end
return GameOver