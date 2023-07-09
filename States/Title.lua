local Title = {}
local bigFont,smallFont,title_img
function Title.load(info)
    bigFont=gr.newFont(30)
    smallFont=gr.newFont(20)
    title_img=gr.newImage('/Assets/title.png')
end

function Title.update(dt)

end

function Title.draw()
    gr.setBackgroundColor(0.2,0,0)
    gr.setColor(1,1,1)
    gr.draw(title_img,screen_w/2,screen_h/2,0,1,1,title_img:getWidth()/2,title_img:getHeight()/2)
    gr.setColor(0.7,0.7,0.7)
    gr.setFont(bigFont)
    --gr.printf('WhamBamMania',0,screen_h/2,screen_w,'center')
    gr.setFont(smallFont)
    gr.printf('Press any key to start',0,screen_h/2+250,screen_w,'center')
end

function Title.keypressed(key)
    States.change('game')
end
function Title.keyreleased(key)
end
return Title