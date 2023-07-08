local Title = {}
local bigFont,smallFont,time
function Title.load(info)
    bigFont=gr.newFont(30)
    smallFont=gr.newFont(20)
    time = info
end

function Title.update(dt)
end

function Title.draw()
    gr.setBackgroundColor(1, 113/255, 0.1)
    gr.setColor(0,0.3,0)
    gr.setFont(bigFont)
    gr.printf('Victory',0,screen_h/2-50,screen_w,'center')
    gr.setFont(smallFont)
    gr.printf('You won in '..string.format('%.2f',tostring(time))..' seconds, congratulations!!',0,screen_h/2,screen_w,'center')
    gr.printf('Press any key to go to title screen',0,screen_h/2+50,screen_w,'center')
end

function Title.keypressed(key)
    States.change('title')
end
function Title.keyreleased(key)
end
return Title