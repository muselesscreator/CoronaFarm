local Super = Pest


--==================================================================================
--====   Air Pests                  ================================================
--==================================================================================

AirPest = Class(Super)
function AirPest:initialize(args)
    Super.initialize(self, args)
    self.base_sprite.alpha = 0
    self.base_sprite.isHitTestable = true

    self.bird_sprite = display.newSprite(myImageSheet, sequenceData)
    self.bird_sprite.y = self.base_sprite.y - 275
    self.bird_sprite.x = self.base_sprite.x
    self.bird_sprite:setSequence('seqBird')
    self.bird_sprite:play()

    self.bird_death = display.newSprite(myImageSheet, sequenceData)
    self.bird_death.y = display.contentHeight/2
    self.bird_death.x = display.contentWidth/2
    self.bird_death.alpha = 0

    self.overlay.x = display.contentWidth / 2
    self.overlay.y = display.contentHeight / 2

    self.turns = 0
    self.maxTurns = 2
    theField:addElement(self)
    self:addSpritesToLayers()
end

function AirPest:addSpritesToLayers()
    theField.birdLayer:insert(self.base_sprite)
    theField.birdLayer:insert(self.bird_sprite)
    theField.birdLayer:insert(self.bird_death)
    theField.birdLayer:insert(self.overlay)
end

function AirPest:nextIsValid()
    print('--AirPest:nextIsValid')
    print(self:whatIsNext().is_weapon)
    return self:whatIsNext().is_weapon
end

function AirPest:doesSpawn()
    r = math.random(0, 100)
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

function AirPest:whereDoesSpawn()
    local opts = {}
    for i, v in pairs(theField.elements) do
        for k, val in ipairs(v) do
            print(val.elem_type)
            if theField:pestAt(val.i, val.j) == false and val.elem_type ~= 'Turtle' then
                print("?")
                opts[#opts+1] = val
            end
        end
    end
    r = math.random(1, #opts)
    return opts[r]
end

function AirPest:myTarget()
    print('--@ AirPest:myTarget')
    local items = theField:whatIsAt(self.i, self.j)
    for i, v in ipairs(items) do
        if v ~= self then
            print(v)
            return v
        end
    end
end

function AirPest:nextDay()
    if not self.dying then
        self.turns = self.turns + 1
        if self.turns == self.maxTurns then
            self:swoop()
        end
    end
end

function AirPest:swoop()
    self.bird_sprite:setSequence('seqSwoop')
    self.bird_sprite:play()
    playSoundEffect('Crow')
    timer.performWithDelay(400, function() self:attack() end, 1)
    timer.performWithDelay(800, function() self:die() end, 1)
end

function AirPest:attack()
    local target = self:myTarget()
    local i = target.i
    local j = target.j
    print(target.elem_type)
    if target.elem_type == 'Barren' then
        target:die()
        local tmp = Urn:new({i=i, j=j}) 
    elseif target.elem_type == 'Plant' then
        target:die()
        local tmp = Barren:new({i=i, j=j, turns_remaining=10})
    end
end

function AirPest:useWeapon()
    self.bird_sprite.alpha = 0
    self.bird_death:setSequence('seqBirdDead')
    self.bird_death.alpha = 1
    self.bird_death:play()
    self.dying = true
    timer.performWithDelay(700, function() self:die() end, 1)
end

function AirPest:die()
    if self.base_sprite ~= nil then
        self.base_sprite:removeSelf()
        self.base_sprite = nil
        self.bird_sprite:removeSelf()
        self.bird_sprite = nil
        self.bird_death:removeSelf()
        self.bird_death = nil
        self.overlay:removeSelf()
        self.overlay = nil
    end
    self:removeFromField()
    self = nil
end

Crow = Class(AirPest)
function Crow:initialize(args)
    AirPest.initialize(self, args)
end

function Crow:spawn()
    local numSpawn = self:doesSpawn()
    if numSpawn > 0 then
        for i=1, numSpawn do
            playSoundEffect('Crow')
            local dest = self:whereDoesSpawn()
            local tmp = Crow:new({i=dest.i, j=dest.j}) 
        end
    end
end

Cockatrice = Class(AirPest)
function Cockatrice:initialize(args)
    AirPest.initialize(self, args)
end

function Cockatrice:spawn()
    if self:doesSpawn() then
        playSoundEffect('Cockatrice')
        local dest = self:whereDoesSpawn()
        local tmp = Cockatrice:new({i=dest.i, j=dest.j}) 
    end
end

function Cockatrice:attack()
    local target = self:myTarget()
    local i = target.i
    local j = target.j
    local seq = target.type
    local frame = target.myStage
    if target.elem_type == 'Plant' then
        target:die()
        local tmp = StonePlant:new({i=i, j=j, type=seq, stage=frame})
    end
end