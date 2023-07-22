local Title = {}
local bigFont,smallFont,title_img,bg_img
function Title.load()
    bigFont=gr.newFont(30)
    smallFont=gr.newFont(20)
    title_img=gr.newImage('/Assets/title.png')
    bg_img=gr.newImage('/Assets/Background_clear.png')
end

function Title.update(dt)

end

function Title.draw()
    gr.setColor(1,1,1)
    gr.draw(bg_img,0,0)
    gr.draw(title_img,screen_w/2,screen_h/2,0,0.6,0.6,title_img:getWidth()/2,title_img:getHeight()/2)
    gr.setColor(0.7,0.7,0.7)
    gr.setFont(bigFont)
    gr.printf('Press any key to start',0,screen_h/2+200,screen_w,'center')
end

function Title.keypressed(key)
    States.change('game')
end
function Title.keyreleased(key)
end
return Title