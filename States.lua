local States = {}

function States.load()
    States['title']= require './States/Title'
    States['game']= require './States/Game'
    States['gameOver']= require './States/GameOver'
    States['victory']= require './States/Victory'
    States.active="title"
    States[States.active].load()
end

function States.change(new_state,info)
    info=info or nil
    States.active=new_state
    States[States.active].load(info)
end

return States