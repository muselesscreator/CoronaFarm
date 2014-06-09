local Super = FarmElement


Obstruction = Class(FarmElement)

function Obstruction:initialize(args)
    Super.initialize(self, args)

    self.elem_type = 'Obstruction'
    
    obs_sprite = display.newSprite(obsSheet, sequenceData)

    obs_sprite.x = self.x
    obs_sprite.y = self.y
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
    layer:insert(self.weapon_sprite)
end

function Obstruction:removeFromField()
    for i, v in ipairs(theField.elements.Obstruction) do
        if v == self then
            table.remove(theField.elements.Obstruction, i)
        end
    end
end

function Obstruction:die()
    print('--@Obs:die()')
    if self.obs_sprite ~= nil then
        print('has obs_sprite')
        self.obs_sprite.alpha = 0
        self.obs_sprite:removeSelf()
        self.obs_sprite = nil
    end
    FarmElement.die(self)
    theField:updateDoomCounter()
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
    tmp = theField:whatIsAt(args.i, args.j)
    for i, v in ipairs(tmp) do
        if v.elem_type == 'Rock' then
            return true
        end
    end
    Obstruction.initialize(self, args)
    self.obs_sprite:setSequence('Rock')
    self.elem_type = 'Rock'
    self.cracked = false
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

        print('mallet on rock')
        self.overlay:setSequence('Mallet')
        self.overlay.alpha = 1
        self.overlay:play()
        vibrate()
        if self.cracked then
            playSoundEffect('break')
            local tmp = Blank:new({i=self.i, j=self.j})
            timer.performWithDelay(250, function() self:die() end, 1)
        else
            self.cracked = true
            playSoundEffect('crack')
            timer.performWithDelay(250, function() 
                self.obs_sprite:setFrame(2) 
                self.overlay.alpha = 0 
                end, 1)
        end
    else
        FarmElement.useWeapon(self)
    end
end

function Rock:useMagicHammer()
    self.overlay:setSequence('MagicMallet')
    self.overlay.y = self.y - 70
    self.overlay.alpha = 1
    self.overlay:play()
    vibrate()
    playSoundEffect('break')
    local tmp = Blank:new({i=self.i, j=self.j})
    timer.performWithDelay(800, function() self:die() end, 1)


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
    self.obs_sprite:setSequence('Stone'..self.type)
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
    self.obs_sprite:setSequence('Barren')
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
    self.obs_sprite:setSequence('Urn')
    self.elem_type = 'Urn'
    theField:updateDoomCounter()
end

function Urn:nextIsValid()
    return false
end

function Urn:nextIsValid()
    return self:whatIsNext().is_weapon
end

--==================================================================================
--====   Turtle                     ================================================
--==================================================================================
Turtle = Class(Obstruction)
function Turtle:initialize(args)
    Obstruction.initialize(self, args)
    self.obs_sprite:setSequence('TurtleS')
    self.elem_type = 'Turtle'
    self.orientation = 'Down'
    self.new_orientation = nil
end

function Turtle:move()
    local opts = {}
    for i, val in pairs(self:getNeighbors()) do
        for j, v in ipairs(val) do
            if v ~= nil then
                if v.elem_type == 'Blank' and self:canMoveTo(v) then
                    opts[#opts+1] = v
                end
            end
        end
    end
    if #opts > 0 then
        r = math.random(1,#opts)
        self.dest = opts[r]
        self:go()
    end

end

function Turtle:canMoveTo(dest)
    if (dest.i > self.i and self.orientation == 'Left') or
        (dest.i < self.i and self.orientation == 'Right') or
        (dest.j < self.j and self.orientation == 'Down') or
        (dest.j > self.j and self.orientation == 'Up') then
        return false
    else
        return true
    end 
end

function Turtle:nextIsValid()
    return false
end

function Turtle:go()
    if self.dest.i > self.i then
        self.new_orientation = 'Right'
    elseif self.dest.i < self.i then
        self.new_orientation = 'Left'
    elseif self.dest.j < self.j then
        self.new_orientation = 'Up'
    else
        self.new_orientation = 'Down'
    end
    if self.new_orientation ~= self.orientation then
        self:turn()
        timer.performWithDelay(125, function() self:walk() end, 1)
    else
        self:walk()
    end
end

function Turtle:flip(doFlip)
    print('FLIP DA TURTLE!')
    if doFlip == true then
        self.obs_sprite.xScale = -1
    else
        self.obs_sprite.xScale = 1
    end
end

function Turtle:turn()
    if self.orientation == 'Down' or self.orientation == 'Up' then
        if self.new_orientation == 'Right' then
            self:flip(false)
        else
            self:flip(true)
        end
        if self.orientation == 'Down' then
            self.obs_sprite:setSequence('TurtleStoE')
        else
            self.obs_sprite:setSequence('TurtleNtoE')
        end
    elseif self.orientation == 'Right' or self.orientation == 'Left' then
        if self.new_orientation == 'Up' then
            self.obs_sprite:setSequence('TurtleEtoN')
        else
            self.obs_sprite:setSequence('TurtleEtoS')
        end
    end
    self.obs_sprite:play()
end

function Turtle:walk()
    local tmp = Blank:new({i=self.i, j=self.j})
    self.i = self.dest.i
    self.j = self.dest.j
    self.dest:die()
    self:deriveXY()
    local new_seq = nil
    if self.new_orientation == 'Up' then
        new_seq = 'TurtleN'
    elseif self.new_orientation == 'Down' then
        new_seq = 'TurtleS'
    else
        new_seq = 'TurtleE'
    end
    self.obs_sprite:setSequence(new_seq)
    self.obs_sprite:play()
    self.orientation = self.new_orientation
    transition.to(self.obs_sprite, {x=self.x, y=self.y, time=500, onComplete=function() self.obs_sprite:setSequence(new_seq) end})
    FarmElement.move(self)
end

function Turtle:nextDay()
    self:move()
end