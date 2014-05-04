local Super = require('Classes.FarmElements.Pest')

--==================================================================================
--====   Land Pests                 ================================================
--==================================================================================

LandPest = Class(Super)
function LandPest:initialize(args)
    print('-- @LandPest before Super')
    Super.initialize(self, args)
    print('-- @LandPest')

    self:addSpritesToLayers()
    theField:addElement(self)

    self.base_sprite:setSequence('seqGopher')
    self.base_sprite:play()

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
    if r <= 15 and (#theField.elements.Pest == 0) and #theField.elements.Blank > 0 then
        return true
    end
    return false
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
                for k, val in pairs(v) do
                    print(k)
                    print(val)
                    print('--------------')
                end
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

function LandPest:eat()
    playSoundEffect('Gophereat')
    self.hunger = 0
    self.numPlants = self.numPlants + 1
    if self.numPlants == 3 then
        self.numPlants = 0
        self:breed()
    end
end

function LandPest:useWeapon()
    local r = math.random(1, 5)
    fn = 'mallet_'..r
    playSoundEffect(fn)
    self.base_sprite.y = self.base_sprite.y - 75
    self.base_sprite:setSequence('seqGopherHammerDie')
    self.base_sprite:play()
    timer.performWithDelay(800, function() self:die() end, 1)
end

function LandPest:starve()
    local r = math.random(1, 4)
    fn = 'starve_'..r
    playSoundEffect(fn)

    self.base_sprite:setSequence('seqGopherDie')
    self.base_sprite:play()
    timer.performWithDelay(800, function() self:die() end, 1)
end

function LandPest:die()
    tmp = Rock:new({i=self.i, j=self.j})
    self.base_sprite:removeSelf()
    self.overlay:removeSelf()
    self:removeFromField()
    self = nil
end

function LandPest:nextDay()
    self.hunger = self.hunger + 1
    self:move()
    if self.hunger > 5 then
        self:starve()
    end
end

function LandPest:breed()
    return true
end

function LandPest:move()
    print('--@LandPest:move')
    dest = self:preferredDest()
    if dest then
        local tmp = Blank:new({i=self.i, j=self.j})
        self.i = dest.i
        self.j = dest.j
        self:deriveXY()
        FarmElement.move(self)
        if dest.elem_type == 'Plant' then
            self:eat()
        end
        self.base_sprite:play()
        dest:die()
    end
end




LazyGopher = Class(LandPest)
function LazyGopher:initialize(args)
    LandPest.initialize(self, args)
end

function LazyGopher:spawn()
    if self:doesSpawn() then
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
        local dest = self:whereDoesSpawn()
        local tmp = SmartGopher:new({i=dest.i, j=dest.j})
        dest:die()
    end
end

function SmartGopher:moveOptions()
    local opts = {}
    for i, v in pairs(self:getNeighbors()) do
        if v ~= nil then
            if (v.elem_type == 'Plant' and v.myStage ~= Plants.rot) or v.elem_type == 'Blank' then
                opts[#opts + 1] = v
            end
        end
    end
    return opts
end