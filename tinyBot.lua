local tinyBot = {}
local bulletsTable = {}
local bossBot = {}
function tinyBot.load(bossBot_param)
    --load in assets here
    tinyBot.sprite=gr.newImage('/Assets/tinyBot.png')
    tinyBot.spriteDash=gr.newImage('/Assets/tinyBot_dash.png')
    tinyBot.heart_img=gr.newImage('/Assets/heart_full.png')
    tinyBot.heartEmpty_img=gr.newImage('/Assets/heart_empty.png')
    tinyBot.dash_sfx=love.audio.newSource('/Assets/SFX/dash.wav','static')
    tinyBot.heal_sfx=love.audio.newSource('/Assets/SFX/heal.wav','static')
    tinyBot.shoot_sfx=love.audio.newSource('/Assets/SFX/shoot.wav','static')
    bossBot=bossBot_param
    new_Bullet = require 'Bullet'
    tinyBot.state='neutral'
    tinyBot.moveSpeed=130
    tinyBot.health=3
    tinyBot.width=50
    tinyBot.height=50
    tinyBot.x=(screen_w/2)-(tinyBot.width/2)
    tinyBot.y=(screen_h*3/4)+100-tinyBot.height
    tinyBot.alive=true
    tinyBot.invencibility=0
    tinyBot.dashDistance=70
    tinyBot.randomDashCooldown=0
    tinyBot.fireCooldown=0
    tinyBot.inDash=0
end
function tinyBot.update(dt,timer)
    --run logic for active state
    tinyBot[tinyBot.state](dt)
    --always moving
    tinyBot.x=tinyBot.x+tinyBot.moveSpeed*dt
    --clamp values to not go offscreen
    tinyBot.x=math.max(tinyBot.x,0)
    tinyBot.x=math.min(tinyBot.x,screen_w-tinyBot.width)
    --timer to avoid random dash spam
    if tinyBot.randomDashCooldown>0 then
        tinyBot.randomDashCooldown=tinyBot.randomDashCooldown-dt
    end
    --checking for victory
    if not tinyBot.alive then
        States.change('victory',timer)
    end
    if tinyBot.inDash>0 then
        tinyBot.inDash=tinyBot.inDash-dt
    else
        tinyBot.inDash=0
    end
end
function tinyBot.draw()
    gr.setColor(1,1,1)
    if tinyBot.inDash>0 then
        gr.draw(tinyBot.spriteDash,tinyBot.x+tinyBot.width/2,tinyBot.y,0,tinyBot.moveSpeed/130,1,tinyBot.spriteDash:getWidth()/2)
    else
        gr.draw(tinyBot.sprite,tinyBot.x+tinyBot.width/2,tinyBot.y,0,tinyBot.moveSpeed/130,1,tinyBot.sprite:getWidth()/2)
    end
    if hitbox then
        gr.setColor(0,0,0.7,0.5)
        gr.rectangle('fill',tinyBot.x,tinyBot.y,tinyBot.width,tinyBot.height)
    end
    --health
    if tinyBot.health==3 then
        gr.draw(tinyBot.heart_img,tinyBot.x-7,tinyBot.y-25,0,2/3,2/3)
    else
        gr.draw(tinyBot.heartEmpty_img,tinyBot.x-7,tinyBot.y-25,0,2/3,2/3)
    end
    if tinyBot.health>=2 then
        gr.draw(tinyBot.heart_img,tinyBot.x+15,tinyBot.y-25,0,2/3,2/3)
    else
        gr.draw(tinyBot.heartEmpty_img,tinyBot.x+15,tinyBot.y-25,0,2/3,2/3)
    end
    --gr.rectangle('fill',tinyBot.x+15,tinyBot.y-25,20,20)
    if tinyBot.health>=1 then
        gr.draw(tinyBot.heart_img,tinyBot.x+37,tinyBot.y-25,0,2/3,2/3)
    else
        gr.draw(tinyBot.heartEmpty_img,tinyBot.x+37,tinyBot.y-25,0,2/3,2/3)
    end
    --gr.rectangle('fill',tinyBot.x+37,tinyBot.y-25,20,20)

    --bullets
    for i,v in pairs(bulletsTable) do
        if v~=nil then
            bulletsTable[i].draw()
        end
    end
end
function tinyBot.underHand()
end
function tinyBot.dash()
    local rand=math.random(3)
    if rand==1 then
        return --do nothing
    elseif rand<=2 then
        tinyBot.dash_sfx:play()
        tinyBot.x=tinyBot.x+tinyBot.dashDistance+(tinyBot.width/2)
        tinyBot.moveSpeed = 90
        tinyBot.inDash = 0.5
    else
        tinyBot.dash_sfx:play()
        tinyBot.x=tinyBot.x-tinyBot.dashDistance+(tinyBot.width/2)
        tinyBot.moveSpeed = -90
        tinyBot.inDash = 0.5
    end
end
function tinyBot.turn()
    tinyBot.moveSpeed = -tinyBot.moveSpeed
end
function tinyBot.damage()
    if tinyBot.health>0 and tinyBot.state ~= 'invencible' then
        tinyBot.health=tinyBot.health-1
        tinyBot.invencibility=4
        tinyBot.state='invencible'
    end
end
function tinyBot.heal()
    if tinyBot.health<3 then
        tinyBot.heal_sfx:play()
        tinyBot.health=tinyBot.health+1
    end
end
function tinyBot.shoot()
    tinyBot.shoot_sfx:play()
    table.insert(bulletsTable,new_Bullet(tinyBot.x+(tinyBot.width/2),tinyBot.y,bossBot))
end
tinyBot['neutral']=function(dt)
    local rand=math.random(100)
    --movement logic
    if tinyBot.health==3 then
        if tinyBot.x>=screen_w-tinyBot.width or tinyBot.x<=0 then
            tinyBot.turn()
        end
    elseif tinyBot.health==2 then
        if tinyBot.x>=screen_w-tinyBot.width or tinyBot.x<=0 then
            tinyBot.turn()
        end
        if rand <= 5 and tinyBot.randomDashCooldown<=0 then
            tinyBot.randomDashCooldown=2
            tinyBot.dash()
        end
    elseif tinyBot.health==1 then
        if tinyBot.x>=screen_w-tinyBot.width or tinyBot.x<=0 then
            tinyBot.turn()
        end
        if rand <= 20 and tinyBot.randomDashCooldown<=0 then
            tinyBot.randomDashCooldown=2
            tinyBot.dash()
        end
    elseif tinyBot.health==0 then
        --death
        tinyBot.alive=false
    end
    --shooting
    tinyBot.fireCooldown = tinyBot.fireCooldown-dt
    if tinyBot.fireCooldown<=0 then
        tinyBot.shoot()
        tinyBot.fireCooldown=0.3
    end
    for i,v in pairs(bulletsTable) do
        if v~=nil then
            bulletsTable[i].update(dt)
        end
    end
end
tinyBot['invencible']=function (dt)
    --invencibility timer
    tinyBot.invencibility=tinyBot.invencibility-dt
    if tinyBot.invencibility<0 then
        tinyBot.invencibility=0
        tinyBot.state='neutral'
    end
    --calls neutral behaviour because it's technically stillneutral
    tinyBot['neutral'](dt)
end
function tinyBot.collide(x,y,width,height)
    if tinyBot.x<=x+width and tinyBot.x+tinyBot.width>=x then
        if tinyBot.y<=y+height and tinyBot.y+height>=y then
            return true
        end
    end
    return false
end
return tinyBot