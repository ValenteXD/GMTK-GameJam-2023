local Title = {}
local bigFont,smallFont
function Title.load(info)
    bigFont=gr.newFont(30)
    smallFont=gr.newFont(20)
    
end

function Title.update(dt)

end

function Title.draw()
    gr.setBackgroundColor(0.2,0,0)
    gr.setColor(0.7,0.7,0.7)
    gr.setFont(bigFont)
    gr.printf('Game name here',0,screen_h/2,screen_w,'center')
    gr.setFont(smallFont)
    gr.printf('Press any key',0,screen_h/2+50,screen_w,'center')
end

function Title.keypressed(key)
    States.change('game')
end
function Title.keyreleased(key)
end
return Title