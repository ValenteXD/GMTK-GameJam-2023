return function (side)
    local hand = {}
    local tinyBot = {}
    local heartsTable = {}
    local heart_img
    hand.side = side
    function hand.load()
        -- load in assets here
        --hand image(remember to mirror according to hand side)
        hand.sprite=gr.newImage('/Assets/hand.png')
        heart_img=gr.newImage('/Assets/heart_full.png')
        hand.smash_sfx=love.audio.newSource('/Assets/SFX/smash.wav','static')
        new_Heart = require 'Heart'
        hand.y=(screen_h/2)+30
        if hand.side=='left' then
            hand.x=(screen_w/2)-300
        elseif hand.side=='right' then
            hand.x=(screen_w/2)+300
        end
        hand.maxHeight=(screen_h/2)+40
        hand.minHeight=(screen_h/2)
        hand.height=120
        hand.width=60
        hand.floatSpeed = -25
        hand.moveSpeed = 100
        hand.state='neutral'
        hand.ground = screen_h*3/4
        hand.stuckTimer = 0
        hand.fakeOutCooldown = 0
        hand.fakeOut=false
        if hand.side=='left' then
            hand.flip = 1
        else
            hand.flip = -1
        end
    end
    function hand.update(dt,tinyBot_param)
        tinyBot = tinyBot_param
        -- I should probably have made a separate update for each state,
        --but I already put me through this hell, so might as well go all the way
        if hand.state=='neutral' then
            hand.y=hand.y+hand.floatSpeed*dt
            if hand.y>=hand.maxHeight or hand.y<=hand.minHeight then
                hand.floatSpeed= -hand.floatSpeed
            end
        end
        if hand.fakeOut and hand.fakeOutCooldown>0 then
            hand.fakeOut=false
        end
        if hand.state=='smash' then
            hand.y=hand.y+hand.moveSpeed*5*dt
            hand.y=math.min(hand.y,hand.ground)
            if tinyBot.collide(hand.x,0,hand.width,screen_h) and math.random(10)==1 then
                tinyBot.dash()
            end
            if hand.y<hand.ground and hand.y>=hand.ground-20 then
                hand.smash_sfx:play()
            end
            if tinyBot.collide(hand.x,hand.y,hand.width,hand.height) and hand.y<hand.ground then
                tinyBot.damage()
            end
            if hand.y>=hand.ground and hand.stuckTimer>0 then
                hand.stuckTimer=hand.stuckTimer-dt
            end
            if hand.stuckTimer<=0 then
                hand.stuckTimer=0
                if math.random(3)==1 then
                    table.insert(heartsTable,new_Heart(hand.x+(hand.width/2),hand.y+hand.height-45,heart_img))
                end
                hand.state='smashRecovery'
            end
        end
        if hand.state=='smashRecovery' then
            hand.y=hand.y-hand.moveSpeed*dt
            hand.y=math.max(hand.y,(screen_h/2)+30)
            if hand.y<=(screen_h/2)+30 then
                hand.state='neutral'
            end
        end
        if hand.state=='fakeOutRecovery' then
            if tinyBot.collide(hand.x,0,hand.width,screen_h) and math.random(10)==1 then
                tinyBot.dash()
            end
            if hand.stuckTimer>0 then
                hand.stuckTimer=hand.stuckTimer-dt
                hand.y=hand.y+hand.moveSpeed*2*dt
            else
                hand.y=hand.y-hand.moveSpeed*dt
                hand.y=math.max(hand.y,(screen_h/2)+30)
                if hand.y<=(screen_h/2)+30 then
                    hand.stuckTimer = 0
                    hand.state='neutral'
                end
            end
        end
        if hand.side=='left' then
            hand.x=math.max(hand.x,0)
        elseif hand.side=='right' then
            hand.x=math.min(hand.x,screen_w-hand.width)
        end
        if hand.fakeOutCooldown>0 then
            hand.fakeOutCooldown=hand.fakeOutCooldown-dt
        elseif hand.fakeOutCooldown<0 then
            hand.fakeOutCooldown=0
        end
        for i,v in pairs(heartsTable) do
            if v~=nil then
                heartsTable[i].update(dt,tinyBot)
            end
        end
    end
    function hand.draw()
        if hitbox then
            gr.setColor(1,0,1,0.5)
            gr.rectangle('fill',hand.x,hand.y,hand.width,hand.height)
        end
        gr.draw(hand.sprite,hand.x+hand.width/2,hand.y,0,hand.flip,1,hand.sprite:getWidth()/2,40)
        --gr.printf(tostring(hand.stuckTimer),0,0,screen_w,hand.side)
        for i,v in pairs(heartsTable) do
            if v~=nil then
                heartsTable[i].draw()
            end
        end
    end
    function hand.move(dt,direction)
        if hand.state == 'neutral' then
            if direction == 'right' then
                hand.x = hand.x + hand.moveSpeed*dt
            elseif direction == 'left' then
                hand.x = hand.x - hand.moveSpeed*dt
            end
        end
    end
    function hand.smash()
        if hand.state == 'neutral' then
            if not hand.fakeOut then
                hand.stuckTimer = 1
                hand.state='smash'
            else
                hand.stuckTimer = 0.25
                hand.state='fakeOutRecovery'
            end
        end
    end
    function hand.toggleFake()
        if hand.fakeOutCooldown<=0 then
            hand.fakeOut= not hand.fakeOut
        end
    end
    return hand
end
