return function(x,y,bossBot_param)
    local bullet = {}
    local bossBot=bossBot_param
    bullet.x=x
    bullet.y=y
    local magnitude=math.sqrt(x^2+y^2)
    bullet.width=10
    bullet.height=bullet.width
    bullet.moveX=(bossBot.x-x)/magnitude
    bullet.moveY=(bossBot.y-y)/magnitude
    bullet.speed = 2000
    function bullet.update(dt)
        if bullet~=nil then
            bullet.x=bullet.x+bullet.moveX*bullet.speed*dt
            bullet.y=bullet.y+bullet.moveY*bullet.speed*dt
            if bossBot.collide(bullet.x,bullet.y,bullet.width,bullet.height) then
                bossBot.damage()
                bullet=nil
            end
        end
    end
    function bullet.draw()
        if bullet~=nil then
            gr.setColor(52/255, 207/255, 235/255)
            gr.rectangle('fill',bullet.x,bullet.y,bullet.width,bullet.height)
        end
    end
    return bullet
end