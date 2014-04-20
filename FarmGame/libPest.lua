require 'class'
--[[
-- Pests:
-- Pests have individual properties, stored in the "Pests" array 

]]--


Pest = class(function(pest, myBreed)
        pest.square = {}
        pest.myBreed = myBreed
        pest.numPlants = 0
        pest.dying = false
        breed = Pests[myBreed]
        for i, v in pairs(breed) do
            pest[i] = v
        end
        pest.turns = 0
        pest.hunger = 0
        if pest.myType == 'land' then
            pest.weapon = 'Mallet'
        else
            pest.weapon = 'Slingshot'
        end
        return pest
    end)

function Pest:random_square()
    while true do
        r_x = math.random(theField.columns)
        r_y = math.random(theField.rows)
        if not theField.grid[r_x][r_y].disabled then
            return theField.grid[r_x][r_y]
        end
    end
end

function key_is_in(x, list)
    for i, v in pairs(list) do
        if x == i then
            return true
        end
    end
    return false
end

function Pest:find_allowed(criteria)
    if self.move_point ~= nil and key_is_in('neighbor', self.move_point) then
        for i, v in pairs(self.square.sprite.neighbors) do
            if v then
                if self:is_allowed(v, self.move_point) then
                    opts[#opts+1] = v
                end
            end
        end
        while true do
            n = math.random(1, #opts)
            tmp = opts[n]
            if self:is_allowed(tmp, self.move_point) then
                break
            end
        end
    else
        while true do
            tmp = self:random_square()
            if self:is_allowed(tmp, criteria) then
                break
            end
        end
    end
    print(tmp.id)
    return tmp
end

function Pest:is_allowed(tmp, criteria)
    print('--@pest:is_allowed')
    print(self.square)
    print(self.square.sprite)
    print(tmp.id)
    --print(self:is_neighbor(tmp))
    local flag = 0
    for i, crit in pairs(criteria) do
        if crit=="empty" and tmp.empty==false then
            flag = 1
        elseif crit=="not blocked" and tmp.blocked then
            flag = 1
        elseif crit=="Mature" and tmp.stage~=plants.mature then
            flag = 1
        elseif crit=="not pest proof" and tmp.pestProof then
            flag = 1
        elseif crit=="not seed" and tmp.isPlant and tmp.stage==0 then
            flag = 1
        elseif crit=="plant" and not tmp.isPlant then
            flag = 1
        elseif crit=="not rotten" and tmp.myStage == 4 then
            flag = 1
        end
    end
    return flag == 0
end

function Pest:find_preferred(criteria)
    print('--@Pest:find_preferred()')
    opts = {}
    for i, v in pairs(self.square.sprite.neighbors) do
        if v then
            if self:is_allowed(v, self.move_point) then
                opts[#opts+1] = v
            end
        end
    end
    n = #opts
    if self.move_priority == 'growth' then
        new_opts = {}
        for i=3, 1, -1 do
            stage = i
            new_opts={}
            for i, v in ipairs(opts) do
                if v.myStage==stage then
                    new_opts[#new_opts+1] = v
                end
            end
            if #new_opts > 0 then
                print('--@Pest:find_preferred() i: '..i)
                break
            end
        end
        if #new_opts > 0 then
            n = math.random(1, #new_opts)
            return new_opts[n].square()
        else
            return false
        end
    end
end

function Pest:spawn()
    print('--@Pest:spawn()')
    local dest = self:find_allowed({'empty', 'not blocked'})
    if self.myType == 'land' then
        print("?asdfasefasdf")
        local arrive = audio.loadStream('sound/GopherLaugh.wav')
        arriveChannel = audio.play( arrive, { channel=0,  fadein=100 } )

    else
        local arrive = audio.loadStream('sound/Cockatrice.wav')
        arriveChannel = audio.play( arrive, { channel=0,  fadein=100 } )

    end
    dest:addPest(self)
    self.square = dest
end

function Pest:move()
    print('-----@Pest:move()')
    if self.dying == true then
        return 0
    end
    local dest = {}
    if self.move_priority then
        dest = self:find_preferred()
        if dest == false then
            print("can't move")
            self.hunger = self.hunger + 1
            if self.hunger == 5 then
                local r = math.random(1, 4)
                fn = 'sound/starve_'..r..'.wav'
                local die_sound = audio.loadStream(fn)
                dieChannel = audio.play( die_sound, { channel=5, fadein=100 } )
                self:die()
            end
            return 0
        end
    else
        print(self.square.sprite)
        dest = self:find_allowed(self.move_point)
    end
    if dest.sprite.isPlant == true then
        print('--@Pest:move() OM NOM BITCHES!   '..self.numPlants)
        local om_nom = audio.loadStream('sound/gopherEat.wav')
        om_nom = audio.play( om_nom, { channel=2, loops=1} )
        self.numPlants = self.numPlants + 1
        self.hunger = 0
        if self.numPlants == 3 then
            print('--@Pest:move() Breeding')
            local new_pest = Pest(self.myBreed)
            theField.pests[self.myBreed][#theField.pests[self.myBreed]+1] = new_pest
            new_pest:spawn()
            self.numPlants = 0
        end
    else
        self.hunger = self.hunger + 1
        print("hunger "..self.hunger.." at "..self.square.id)
        if self.hunger == 5 then

            self:die()
            return 0
        end
    end
    if self.square.id ~= dest.id then
        print("I've moved")
        self.square:clearImage()
        dest:addPest(self)
        self.square = dest
    end
end

function Pest:die(killed)
    killed = killed == nil and true or killed
    print('Pest:die()')
    if self.myType == 'land' then
        if killed == true then
            local r = math.random(1, 7)
            fn = 'sound/mallet_'..r..'.wav'
            local die_sound = audio.loadStream(fn)
            dieChannel = audio.play( die_sound, { channel=5, fadein=100 } )
            self.square.sprite:setSequence('seqGopherDie')
            self.square.sprite:play()
            self.dying = true
            local function die()
                self:die(false)
            end
            timer.performWithDelay(800, die, 1)
            for i, val in ipairs(theField.pests[self.myBreed]) do
                print(val.square.id)
                if val.square == self.square then
                    table.remove(theField.pests[self.myBreed], i)
                    break
                end
            end
        else
            self.square:setImage('Rock')
        end
    elseif self.myType == 'air' then
        if killed == true then
            print('--@pest:die killed')
            self.square.sprite.pest = false
            self.square.birdLayer:setSequence('seqBirdDead')
            self.square.birdLayer:play()
            self.dying = true
            local function fall()
                self:die(false)
            end
            for i, val in ipairs(theField.pests[self.myBreed]) do
                print(val.square.id)
                if val.square == self.square then
                    table.remove(theField.pests[self.myBreed], i)
                    break
                end
            end
            timer.performWithDelay(1500, fall, 1)
        else
            print('--@pest:die not killed')
            self.square.sprite.pest = false
            self.square.birdLayer.alpha=0
            for i, val in ipairs(theField.pests[self.myBreed]) do
                print(val.square.id)
                if val.square == self.square then
                    table.remove(theField.pests[self.myBreed], i)
                    break
                end
            end
        end
    end
    if killed == true then
        print ('--@Pest:die my breed = '..self.myBreed)
        for i, val in ipairs(theField.pests[self.myBreed]) do
            print(val.square.id)
            if val.square == self.square then
                table.remove(theField.pests[self.myBreed], i)
                break
            end
        end
    else
        print('delete self')
        self=nil
    end
end

function Pest:kill()
    print '--@Pest:kill()'
    if self.square.sprite.isPlant then
        if self.kill_act == 'rock' then
            print('make rock')
            self.square:setImage('Rock')
        elseif self.kill_act == 'barren5' then
            print('make barren')
            print(self.square.id)
            self.square:makeBarren()
            self.square.sprite.toNext=10
        end
    end
end

function Pest:next_day()
    print('--@Pest:next_day')
    if self.myType == 'land' then
        self:move()
    elseif self.myType == 'air' then
        if self.turns == self.turns_to_act and self.dying == false then
            start = system.getTimer()
            self.square:birdSwoop()
            local om_nom = audio.loadStream('sound/Crow.wav')
            om_nom_channel = audio.play( om_nom, { channel=3, fadein=100 } )
            local function swoop()
                self:kill()
                local function leave()
                    self:die(false)
                end
                print(self.square.sprite.isBarren)
                timer.performWithDelay(600, leave, 1)
            end
            print(self.square.id)
            timer.performWithDelay(200, swoop, 1)
        elseif self.turns_to_act > 0 then
            self.turns = self.turns + 1
        end
    end
end


Pests = {}
Pests.Gopher = {
    image='seqGopher',
    move_point={"not blocked", "not pest proof", "not rotten", "neighbor"},
    move_priority = false,
    myType = 'land',
}
Pests.LazyGopher = {
    image = 'seqGopher',
    move_point = {'neighbor', 'plant', 'not seed', 'not rotten'},
    move_priority = 'growth',
    myType = 'land'
}
Pests.Crow = {
    image = 'seqBird',
    kill_act = 'barren5',
    turns_to_act = 1,
    myType = 'air'
}
Pests.Cockatrice = {
    image = 'seqBird',
    kill_act = 'rock',
    turns_to_act = 1,
    myType = 'air'
}

function Pests.does_spawn(pest)
    local myType = Pests[pest].myType
    r = math.random(1, 100)
    print('--@Pests.does_spawn():  r = '..r)
    --debug code to 
    if no_pests then
        return 0
    end
    if myType == 'land' then
        if r <= 50 and (#theField.pests[pest] == 0) then
            return true
        end
    elseif myType == 'air' then

        chances = {0, 0, 0, 0, 0}
        local i = theField.turns
        if i <= 10 then
            chances[0] = 50-(i/2)
            chances[1] = 50
            chances[2] = i/2
        elseif i <= 50 then
            chances[0] = 45-(1-10)/4
            chances[1] = 50
            chances[2] = 5+(i-10)/4
            chances[3] = (i-10)/8
        elseif i <= 100 then
            chances[0] = 45-(i/5)
            chances[1] = 55-(i/5)
            chances[2] = 5+(i/10)
            chances[3] = i/10
            chances[4] = i/10 - 5
        elseif i <= 200 then
            chances[0] = 25
            chances[1] = 60-(3*i)/20
            chances[2] = 15
            chances[3] = 5+(1/20)
            chances[4] = i/20
            chances[5] = 1/20-5
        else

        end
        total = 0
        for i, v in ipairs(chances) do
            if r <= total + v then
                return i
            end
            total = total + v
        end
        return 0
    end
end
