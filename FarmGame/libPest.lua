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
        pest.killing = false
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
    print('--@find_allowed')
    square = theField.first
    opts = {}
    while square do
        if self:is_allowed(square.sprite, criteria) then
            opts[#opts+1] = square
        end
        square = square.next
    end
    if #opts > 0 then
        while true do
            tmp = self:random_square()
            if self:is_allowed(tmp.sprite, criteria) then
                break
            end
        end
    else
        return false
    end
    print('--@find_allowed: '..tmp.id)
    return tmp
end

function Pest:is_allowed(tmp, criteria)
    --print(self:is_neighbor(tmp))
    local flag = 0
    for i, crit in pairs(criteria) do
        if crit=="empty" and tmp.empty==false then
            print('EMPTY')
            flag = 1
        elseif crit=="not blocked" and tmp.square().blocked then
            flag = 1
        elseif crit=="Mature" and tmp.stage~=plants.mature then
            flag = 1
        elseif crit=="not pest proof" and tmp.pestProof then
            flag = 1
        elseif crit=="not seed" and tmp.isPlant and tmp.stage==0 then
            flag = 1
        elseif crit=="plant" and not tmp.isPlant then
            flag = 1
        elseif crit=="not rotten" and tmp.myStage == Plants.rot then
            flag = 1
        end
    end
    return flag == 0
end

function Pest:find_preferred(criteria)
    opts = {}
    for i, v in pairs(self.square.sprite.neighbors) do
        if v then
            if self:is_allowed(v, self.move_point) or (self:is_allowed(v, {'empty', 'not blocked'}) and fieldType == 'Salsa') then
                opts[#opts+1] = v
            end
        end
    end
    n = #opts 
    if n > 0 then
        new_opts = {}
        for i=Plants.mature, 0, -1 do
            stage = i
            new_opts={}
            for j, v in ipairs(opts) do
                if stage > 0 and v.myStage==stage then
                    new_opts[#new_opts+1] = v
                elseif stage == 0 and self:is_allowed(v, {'empty', 'not blocked'}) then
                    new_opts[#new_opts+1] = v
                end
            end
            if #new_opts > 0 then
                break
            end
        end
        if #new_opts > 0 then
            n = math.random(1, #new_opts)
            return new_opts[n].square()
        else
            return false
        end
    else
        return false
    end
end

function Pest:spawn()
    print('--@Pest:spawn()')
    local dest = self:find_allowed({'empty', 'not blocked'})
    if dest then
        if self.myType == 'land' then
            local arrive = audio.loadStream('sound/GopherLaugh.wav')
            arriveChannel = audio.play( arrive, { channel=0,  fadein=100 } )

        else
            local arrive = audio.loadStream('sound/Cockatrice.wav')
            arriveChannel = audio.play( arrive, { channel=0,  fadein=100 } )
        end
        dest:addPest(self)
        self.square = dest
    end
end

function Pest:move()
    print('-----@Pest:move()')
    if self.dying == true then
        print('--@Pest:move DYING!')
        return 0
    end
    local dest = {}
    if self.move_priority then
        dest = self:find_preferred()
        print('--@Pest:move find_prefered():')
        print(dest)
        if dest == false then
            print("can't move")
            self.hunger = self.hunger + 1
            if self.hunger == 5 then
                local r = math.random(1, 4)
                fn = 'sound/starve_'..r..'.wav'
                local die_sound = audio.loadStream(fn)
                dieChannel = audio.play( die_sound, { channel=5, fadein=100 } )
                self.square.sprite:setSequence('seqGopherDie')
                self.square.sprite:play()
                self:die()
            end
            return 0
        end
    else
        dest = self:find_allowed(self.move_point)
    end
    if dest then
        if dest.sprite.isPlant == true then
            print('--@Pest:move() OM NOM BITCHES!   '..self.numPlants)
            local om_nom = audio.loadSound('sound/GopherEat.wav')
            om_nom = audio.play( om_nom )
            self.numPlants = self.numPlants + 1
            self.hunger = 0
            if self.numPlants == 3 then
                if #theField.pests[self.myBreed] < theField.maxPests then
                    print('--@Pest:move() Breeding')
                    local new_pest = Pest(self.myBreed)
                    theField.pests[self.myBreed][#theField.pests[self.myBreed]+1] = new_pest
                    new_pest:spawn()
                end
                self.numPlants = 0
            end
        else
            self.hunger = self.hunger + 1
            print("hunger "..self.hunger.." at "..self.square.id)
            if self.hunger == 5 then
                self.square.sprite:setSequence('seqGopherDie')
                self.square.sprite:play()
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
end

function Pest:die(killed)
    killed = killed == nil and true or killed
    print('Pest:die()')
    if self.myType == 'land' then
        if killed == true then
            local r = math.random(1, 5)
            fn = 'sound/mallet_'..r..'.wav'
            local die_sound = audio.loadStream(fn)
            dieChannel = audio.play( die_sound, { channel=5, fadein=100 } )
            self.dying = true
            local function die()
                self:die(false)
            end
            print('800 before "die"')
            timer.performWithDelay(800, die, 1)
            for i, val in ipairs(theField.pests[self.myBreed]) do
                print(val.square.id)
                if val.square == self.square then
                    table.remove(theField.pests[self.myBreed], i)
                    break
                end
            end
        else
            self.square:setSequence('seqGopherDie')
            self.square.weaponLayer.alpha = 0
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
            self.square.weaponLayer.alpha = 0

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
    print(self.square.sprite.isBarren)
    if self.square.sprite.isPlant then
        if self.kill_act == 'rock' then
            print('make rock')
            --self.square.sprite.stonePlant = true
            self.pestProof = true

            self.square:setImage('Rock')
        elseif self.kill_act == 'barren5' and self.square.myType ~= 'Rock' then
            print(self.square.sprite.isBarren)
            if self.square.sprite.isBarren then
                print("BARREN TO ROCK!!!!!!!!!!!!!!")
                self.square:setImage('Rock')
            else
                print('make barren')
                print(self.square.id)
                self.square:makeBarren()
                self.square.sprite.toNext=15
            end
        end
    end
end

function Pest:next_day()
    print('--@Pest:next_day')
    if self.myType == 'land' then
        self:move()
    elseif self.myType == 'air' then
        if self.turns == self.turns_to_act and self.dying == false and self.killing == false then
            self.killing = true
            self.square:birdSwoop()
            local om_nom = audio.loadStream('sound/Crow.wav')
            om_nom_channel = audio.play( om_nom, { channel=3, fadein=100 } )
            local function swoop()
                self:kill()
                local function leave()
                    self:die(false)
                end
                timer.performWithDelay(600, leave, 1)
            end
            print('IS BARREN??????????')
            print(self.square.sprite.isBarren)
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
    move_point = {'neighbor', 'not pest proof', 'plant', 'not seed', 'not rotten'},
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
        if r <= 15 and (#theField.pests[pest] == 0) then
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
            chances[0] = 25
            chances[1] = 30
            chances[2] = 15
            chances[3] = 15
            chances[4] = 10
            chances[5] = 5
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
