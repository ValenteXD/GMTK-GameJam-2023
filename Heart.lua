return function (x,y)--,image)
    local heart = {}
    heart.x=x
    heart.y=y
    heart.width=30
    heart.height=30
    --heart.sprite=image
    function heart.update(dt,tinyBot)
        if heart~=nil then
            if tinyBot.collide(heart.x,heart.y,heart.width,heart.height) then
                heart=nil
                tinyBot.heal()
            end
        end
    end
    function heart.draw()
        if heart~=nil then
            if hitbox then
                gr.setColor(245/255, 66/255, 218/255)
                gr.rectangle('fill',heart.x,heart.y,heart.width,heart.height)
            end
        end
    end

    return heart
end