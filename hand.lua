return function (side)
    local hand = {}
    hand.side = side
    function hand.load()
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
    end
    function hand.update(dt)
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
            hand.y=hand.y+hand.moveSpeed*3*dt
            hand.y=math.min(hand.y,hand.ground)
            if hand.y>=hand.ground and hand.stuckTimer>0 then
                hand.stuckTimer=hand.stuckTimer-dt
            end
            if hand.stuckTimer<=0 then
                hand.stuckTimer=0
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
    end
    function hand.draw()
        gr.rectangle('fill',hand.x,hand.y,hand.width,hand.height)
        gr.printf(tostring(hand.stuckTimer),0,0,screen_w,hand.side)
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
        if not hand.fakeOut then
            hand.stuckTimer = 1
            hand.state='smash'
        else
            hand.stuckTimer = 0.25
            hand.state='fakeOutRecovery'
        end
    end
    function hand.toggleFake()
        if hand.fakeOutCooldown<=0 then
            hand.fakeOut= not hand.fakeOut
        end
    end
    return hand
end