local Game = {}
local pause,selected,tinyBot,bossBot
function Game.load(info)
    selected = true
    pause = false
    tinyBot = require '../tinyBot'
    bossBot = require '../bossBot'
    tinyBot.load()
    bossBot.load()
    --load background image here
end

function Game.update(dt)
    if not pause then
        tinyBot.update(dt)
        bossBot.update(dt)
    end
end

function Game.draw()
    gr.setBackgroundColor(1,1,0)
    --Background image should be here


    gr.setColor(1,1,1)
    tinyBot.draw()
    bossBot.draw()

    -- pause menu stuff
    if pause then
        --darken background
        gr.setColor(0,0,0,0.6)
        gr.rectangle('fill',0,0,screen_w,screen_h)
        --menu screen
        gr.setColor(0.65,0.65,0.65,1)
        gr.rectangle('fill',screen_w*3/8,screen_h*3/8,screen_w/4,screen_h/4)
        --menu text
        if selected then gr.setColor(26/255, 26/255, 237/255) else gr.setColor(0,0,0) end
        gr.printf('Continue',screen_w*3/8,(screen_h*3/8)+15,screen_w/4,'center')
        if not selected then gr.setColor(26/255, 26/255, 237/255) else gr.setColor(0,0,0) end
        gr.printf('Back to title screen',screen_w*3/8,(screen_h*3/8)+45,screen_w/4,'center')
    end
end

function Game.keypressed(key)
    
    --Just pause stuff
    if  key == 'escape' and bossBot.alive then
        pause = not pause
    end
    if pause then
        if key == "up" or key == 'w' or key == 'down' or key == 's' then
            selected = not selected
        end
        if key == 'return' or key == 'space' then
            if selected then
                pause=false
            else
                States.change('title')
            end
        end
    end

    tinyBot.keypressed(key)
    bossBot.keypressed(key)
end
function Game.keyreleased(key)
    tinyBot.keyreleased(key)
    bossBot.keyreleased(key)
end
return Game