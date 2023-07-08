local bossBot = {}
local leftHand, rightHand,head
function bossBot.load()
    --load in assets here
    bossBot.alive=true
    head={}
    head.maxHeight=(screen_h/2)+20
    head.minHeight=(screen_h/2)-20
    head.height=240
    head.width=240
    head.x=(screen_w/2)
    head.y=(screen_h/2)
    head.floatSpeed = 15
    Hand = require 'hand'
    leftHand = Hand('left')
    rightHand = Hand('right')
    leftHand.load()
    rightHand.load()
end
function bossBot.update(dt)
    --States.change('gameOver')
    leftHand.update(dt)
    rightHand.update(dt)
    rightHand.x=math.max(rightHand.x,leftHand.x+leftHand.width)
    leftHand.x=math.min(leftHand.x,rightHand.x-leftHand.width)
    head.y=head.y+head.floatSpeed*dt
    if head.y>=head.maxHeight or head.y<=head.minHeight then
        head.floatSpeed= -head.floatSpeed
    end
    if kb.isDown('a') then
        leftHand.move(dt,'left')
    elseif kb.isDown('d') then
        leftHand.move(dt,'right')
    end
    if kb.isDown('left') then
        rightHand.move(dt,'left')
    elseif kb.isDown('right') then
        rightHand.move(dt,'right')
    end
end
function bossBot.draw()
    gr.setColor(1,0,0)
    gr.rectangle('fill',head.x-(head.width/2),head.y-head.height+10,head.height,head.width)
    leftHand.draw()
    rightHand.draw()
end
function bossBot.keypressed(key)
    if key == 's' then
        if leftHand.fakeOut then
            leftHand.fakeOutCooldown=5
            rightHand.fakeOutCooldown=5
        end
        leftHand.smash()
    end
    if key == 'down' then
        if rightHand.fakeOut then
            leftHand.fakeOutCooldown=5
            rightHand.fakeOutCooldown=5
        end
        rightHand.smash()
    end
    if key == 'space' then
        leftHand.toggleFake()
        rightHand.toggleFake()
    end
end
function bossBot.keyreleased(key)
end
return bossBot