local Super = FarmElement
Obstruction = Class(FarmElement)

function Obstruction:initialize(args)
    Super.initialize(self, args)
    self.elem_type = 'Obstruction'
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

function Obstruction:removeFromField()
    for i, v in ipairs(theField.elements.Obstruction) do
        if v == self then
            table.remove(theField.elements.Obstruction, i)
        end
    end
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
    self.base_sprite:setSequence('seqRock')
end

--Done
function Rock:nextIsValid()
    return self:whatIsNext().is_weapon
end
--Done?
function Rock:useWeapon()
    print('-- @ Rock UseWeapon')
    weapon = self:whatIsNext().value
    if weapon == 'Mallet' then
        print('breakRock')
        --set break animation. wait before blank
        local tmp = Blank:new({i=self.i, j=self.j})
        self:die()
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

    self.base_sprite:setSequence('seqStone'..plant.type)
    self.base_sprite:setFrame(plant.myStage)
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
    self.base_sprite:setSequence('seqBarren')
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



--==================================================================================
--====   Urn                        ================================================
--==================================================================================

Urn = Class(Obstruction)
function Urn:initialize(args)
    Obstruction.initialize(self, args)
    self.elem_type = 'Urn'
end

function Urn:nextIsValid()
    return self:whatIsNext().is_weapon
end