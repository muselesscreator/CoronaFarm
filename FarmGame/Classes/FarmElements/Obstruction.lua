local Super = FarmElement


Obstruction = Class(FarmElement)

function Obstruction:initialize(args)
    print('before FE.init')
    print(args.i)
    Super.initialize(self, args)

    self.elem_type = 'Obstruction'
    
    obs_sprite = display.newSprite(obsImageSheet, obsSequenceData)
    obs_sprite.x = self.x
    obs_sprite.y = self.y
    obs_sprite.alpha = 0
    self.base_sprite.alpha = 0
    self.base_sprite.isHitTestable = true
    self.obs_sprite = obs_sprite

    theField:addElement(self)

    self:addSpritesToLayers()
end

function Obstruction:onClick()
    if self:canClick() then
        self:useWeapon()
        timer.performWithDelay(250, function() 
            theField:nextDay()
            self:useNext()
            end, 1)
    end
end

function Obstruction:addSpritesToLayers()
    local layer = theField.layers[self.j]
    layer:insert(self.base_sprite)
    layer:insert(self.obs_sprite)
    layer:insert(self.overlay)
end

function Obstruction:removeFromField()
    for i, v in ipairs(theField.elements.Obstruction) do
        if v == self then
            table.remove(theField.elements.Obstruction, i)
        end
    end
end

function Obstruction:die()
    if self.obs_sprite ~= nil then
        self.obs_sprite:removeSelf()
        self.obs_sprite = nil
    end
    FarmElement.die(self)
end
--==================================================================================
--====   Turtle                     ================================================
--==================================================================================

Turtle = Class(Obstruction)

function Turtle:initialize(args)
    Obstruction.initialize(self, args)
    self.elem_type = 'Turtle'
end

function Turtle:move()
    local opts = {}
    for i, v in pairs(self:getNeighbors()) do
        if v.elem_type == 'Blank' then
            opts[#opts+1] = v
        end
    end
    if #opts > 0 then
        r = math.random(1, #opts)
        new_i = opts[r].i
        new_j = opts[r].j
        opts[r]:die()
        --transition.to(self.base_sprite, )
    end
end
--Done
function Turtle:nextDay()
    self:move()
end
--Done
function Turtle:isNextValid()
    return self:whatIsNext().is_weapon
end

--==================================================================================
--====   Rock                       ================================================
--==================================================================================

Rock = Class(Obstruction)
function Rock:initialize(args)
    Obstruction.initialize(self, args)
    self.obs_sprite:setSequence('seqRock')
    self.elem_type = 'Rock'
end

--Done
function Rock:nextIsValid()
    print('Rock:nextIsValid')
    return self:whatIsNext().is_weapon
end
--Done?
function Rock:useWeapon()
    print('-- @ Rock UseWeapon')
    weapon = self:whatIsNext().type
    print(weapon)

    if weapon == 'Mallet' then
        print('breakRock')
        self.overlay:setSequence('seqMallet')
        self.overlay.alpha = 1
        self.overlay:play()
        local tmp = Blank:new({i=self.i, j=self.j})
        timer.performWithDelay(250, function() self:die() end, 1)
    else
        FarmElement.useWeapon(self)
    end
end

--==================================================================================
--====   StonePlant                 ================================================
--==================================================================================

--Done
StonePlant = Class(Obstruction)
function StonePlant:initialize(args)
    Obstruction.initialize(self, args)
    self.type = args.type
    self.myStage = args.stage
    self.elem_type = 'StonePlant'
    self.obs_sprite:setSequence('seqStone'..self.type)
    self.obs_sprite:setFrame(self.myStage)
end
--Done
function StonePlant:nextIsValid()
    return self:whatIsNext().is_weapon
end

--==================================================================================
--====   Barren                     ================================================
--==================================================================================

Barren = Class(Obstruction)
function Barren:initialize(args)
    Obstruction.initialize(self, args)
    self.elem_type = 'Barren'
    self.obs_sprite:setSequence('seqBarren')
    self.progress = 0
    self.turns_remaining = args.turns_remaining
end
--Done
function Barren:nextDay()
    self.progress = self.progress + 1
    if self.progress > self.turns_remaining then
        tmp = Blank:new({i=self.i, j=self.j})
        self:die()
    end
end
--Done
function Barren:nextIsValid()
    return self:whatIsNext().is_weapon
end

function Barren:die()
    self.obs_sprite:removeSelf()
    FarmElement.die(self)
end

--==================================================================================
--====   Urn                        ================================================
--==================================================================================

Urn = Class(Obstruction)
function Urn:initialize(args)
    Obstruction.initialize(self, args)
    self.obs_sprite:setSequence('seqRock')
    self.elem_type = 'Urn'
end

function Urn:nextIsValid()
    return false
end

function Urn:nextIsValid()
    return self:whatIsNext().is_weapon
end