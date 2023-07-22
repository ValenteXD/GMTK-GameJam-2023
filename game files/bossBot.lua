local bossBot = {}
local leftHand, rightHand
function bossBot.load()
    --load in assets here--
    bossBot.sprite=gr.newImage('/Assets/head_normal.png')
    bossBot.spriteInFakeOut=gr.newImage('/Assets/head_fakeOut.png')
    bossBot.lifebar_img=gr.newImage('/Assets/lifebar.png')
    bossBot.fakeOutIcon=gr.newImage('/Assets/fakeOut.png')
    --head fakeOut image
    bossBot.alive=true
    bossBot.maxHeight=(screen_h/2)+20
    bossBot.minHeight=(screen_h/2)-20
    bossBot.height=240
    bossBot.width=240
    bossBot.x=(screen_w/2)
    bossBot.y=(screen_h/2)
    bossBot.floatSpeed = 15
    Hand = require 'hand'
    leftHand = Hand('left')
    rightHand = Hand('right')
    leftHand.load()
    rightHand.load()
    bossBot.health=500
end
function bossBot.update(dt,tinyBot)
    if bossBot.health <= 0 then
        bossBot.alive=false
    end
    if not bossBot.alive then
        States.change('gameOver')
    end
    leftHand.update(dt,tinyBot)
    rightHand.update(dt,tinyBot)
    rightHand.x=math.max(rightHand.x,leftHand.x+leftHand.width+2)
    leftHand.x=math.min(leftHand.x,rightHand.x-leftHand.width-2)
    bossBot.y=bossBot.y+bossBot.floatSpeed*dt
    if bossBot.y>=bossBot.maxHeight or bossBot.y<=bossBot.minHeight then
        bossBot.floatSpeed= -bossBot.floatSpeed
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
    gr.setColor(1,1,1)
    if rightHand.fakeOut then
        gr.draw(bossBot.spriteInFakeOut,bossBot.x-(bossBot.width/2)-40,bossBot.y-bossBot.height-35,0,1.4)
    else
        gr.draw(bossBot.sprite,bossBot.x-(bossBot.width/2)-40,bossBot.y-bossBot.height-35,0,1.4)
    end
    if hitbox then
        gr.setColor(1,0,0,0.5)
        gr.rectangle('fill',bossBot.x-(bossBot.width/2),bossBot.y-bossBot.height+10,bossBot.height,bossBot.width)
    end
    gr.setColor(1,1,1)
    gr.draw(bossBot.lifebar_img,0,0,0,0.77,1)
    gr.setColor(1,0,0)
    gr.rectangle('fill',20,18,bossBot.health,37)
    gr.setColor(1,1,1)
    gr.draw(bossBot.fakeOutIcon,20,300)
    gr.rectangle('fill',20,300,50,leftHand.fakeOutCooldown*10)
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
function bossBot.collide(x,y,width,height)
    if bossBot.x<=x+width and bossBot.x+bossBot.width>=x then
        if bossBot.y<=y+height and bossBot.y+height>=y then
            return true
        end
    end
    return false
end
function bossBot.damage()
    bossBot.health=bossBot.health-1
end
return bossBot