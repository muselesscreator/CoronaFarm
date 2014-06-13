local Super = require('Classes.FarmElements.Pest')

--==================================================================================
--====   Land Pests                 ================================================
--==================================================================================

LandPest = Class(Super)
function LandPest:initialize(args)
    Super.initialize(self, args)

    self:addSpritesToLayers()
    theField:addElement(self)

    self.pest_sprite:setSequence('Gopher')
    self.pest_sprite:play()

    self.numPlants = 0
    self.hunger = 0
end

--==================================
--==Functions to return things  ====
--==================================
function LandPest:doesSpawn()
    r = math.random(1, 100)
    if no_pests then
        return 0
    end
    if r <= 15 and (#theField.elements.Pest == 0) and self:canSpawn() then
        return true
    end
    return false
end

function LandPest:canSpawn()
    return #theField.elements.Blank > 0
end

function LandPest:whereDoesSpawn()
    r = math.random(1, #theField.elements.Blank)
    tmp = theField.elements.Blank[r]
    return tmp
end

function LandPest:moveOptions()
    local opts = {}
    for i, v in pairs(self:getNeighbors()) do
        if #v > 0 then
            for j, val in ipairs(v) do
                if val ~= nil then
                    if (val.elem_type == 'Plant' and val.myStage ~= Plants.rot) then
                        opts[#opts + 1] = val
                    end
                end
            end
        end
    end
    return opts
end

function LandPest:preferredDest()
    local opts = self:moveOptions()
    print('-- @LandPest:preferredDest')
    print(#opts)
    n = #opts 
    if n > 0 then
        new_opts = {}
        for i=Plants.mature, 0, -1 do
            stage = i
            new_opts={}
            for j, v in ipairs(opts) do
                if stage > 0 and v.myStage==stage then
                    new_opts[#new_opts+1] = v
                elseif stage == 0 and v.elem_type == 'Blank' then
                    new_opts[#new_opts+1] = v
                end
            end
            if #new_opts > 0 then
                break
            end
        end
        if #new_opts > 0 then
            n = math.random(1, #new_opts)
            return new_opts[n]
        else
            return false
        end
    else
        return false
    end
end

--==============================
--==Functions to Do things  ====
--==============================


function LandPest:nextDay()
    self.hunger = self.hunger + 1
    if not self.dying then
        self:move()
        if self.hunger > 5 then
            self:starve()
        end
    end
end


function LandPest:move()
    print('--@LandPest:move')
    dest = self:preferredDest()
    if dest then
        local tmp = Blank:new({i=self.i, j=self.j})
        self.i = dest.i
        self.j = dest.j
        self:deriveXY()
        Pest.move(self)
        if dest.elem_type == 'Plant' then
            self:eat()
        end
        self.pest_sprite:play()
        dest:die()
    end
end

function LandPest:eat()
    playSoundEffect('Gophereat')
    self.hunger = 0
    self.numPlants = self.numPlants + 1
    if self.numPlants == 3 then
        self.numPlants = 0
        self:breed()
    end
end

function LandPest:breed()
    print('-- @LandPest:breed')
    self:spawn()
end

function LandPest:starve()
    local r = math.random(1, 4)
    fn = 'starve_'..r
    playSoundEffect(fn)

    self.pest_sprite:setSequence('GopherDie')
    self.pest_sprite:play()
    timer.performWithDelay(800, function() self:die() end, 1)
end

function LandPest:useWeapon()
    local r = math.random(1, 5)
    fn = 'mallet_'..r
    playSoundEffect(fn)
    self.dying = true
    self.rock = Rock:new({i=self.i, j=self.j})
    if self.rock.obs_sprite ~= nil then
        print("@@@@!!!!!!!!!Rock sprite did not die!")
        self.rock.obs_sprite.alpha = 0
    end
    self.pest_sprite.y = self.pest_sprite.y - 75
    self.pest_sprite:setSequence('GopherHammerDie')
    vibrate()
    self.pest_sprite:play()
    timer.performWithDelay(800, function() self:die() end, 1)
end

function LandPest:useMagicHammer()
    playSoundEffect('magicHammer')
    self.dying = true
    self.pest_sprite.y = self.pest_sprite.y - 85
    self.pest_sprite.x = self.pest_sprite.x + 5
    self.pest_sprite:setSequence('GopherMagicHammerDie')
    vibrate()
    local tmp = Blank:new({i=self.i, j=self.j})
    self.pest_sprite:play()
    timer.performWithDelay(800, function() Pest.die(self) end, 1)
end

function LandPest:die()
    if self.rock == nil then
        local tmp = Rock:new({i=self.i, j=self.j})
    else
        self.rock.obs_sprite.alpha = 1
    end
    theField:updateDoomCounter()
    Pest.die(self)
end





LazyGopher = Class(LandPest)
function LazyGopher:initialize(args)
    LandPest.initialize(self, args)
end

function LazyGopher:spawn()
    if self:doesSpawn() then
        playSoundEffect('GopherLaugh')
        local dest = self:whereDoesSpawn()
        tmp = LazyGopher:new({i=dest.i, j=dest.j})
        dest:die()
    end
end

function LazyGopher:breed()
    if self:canSpawn() then
        local dest = self:whereDoesSpawn()
        tmp = LazyGopher:new({i=dest.i, j=dest.j})
        dest:die()
    end
end




SmartGopher = Class(LandPest)
function SmartGopher:initialize(args)
    LandPest.initialize(self, args)
end

function SmartGopher:spawn()
    if self:doesSpawn() then
        playSoundEffect('GopherLaugh')
        local dest = self:whereDoesSpawn()
        local tmp = SmartGopher:new({i=dest.i, j=dest.j})
        dest:die()
    end
end

function SmartGopher:moveOptions()
    local opts = {}
    for i, v in pairs(self:getNeighbors()) do
        if #v > 0 then
            for j, val in ipairs(v) do
                if val ~= nil then
                    if (val.elem_type == 'Plant' and val.myStage ~= Plants.rot) or val.elem_type == 'Blank' then
                        opts[#opts + 1] = val
                    end
                end
            end
        end
    end
    return opts
end

function SmartGopher:breed()
    if self:canSpawn() then
        local dest = self:whereDoesSpawn()
        tmp = SmartGopher:new({i=dest.i, j=dest.j})
        dest:die()
    end
end