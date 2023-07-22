local Title = {}
local bigFont,smallFont,time,bg_img
function Title.load(info)
    bigFont=gr.newFont(50)
    smallFont=gr.newFont(20)
    time = info
    victory_sfx=love.audio.newSource('/Assets/SFX/victory.wav','static')
    bg_img=gr.newImage('/Assets/Background_clear.png')
    victory_sfx:play()
end

function Title.update(dt)
end

function Title.draw()
    gr.draw(bg_img,0,0)
    gr.setColor(0.8,0.8,0)
    gr.setFont(bigFont)
    gr.printf('Victory!!!',0,screen_h/2-75,screen_w,'center')
    gr.setColor(0.8,0.8,0.8)
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