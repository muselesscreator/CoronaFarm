local Super = FarmElement
Pest = Class(Super)

function Pest:initialize(args)
    Super.initialize(self, args)
    self.pest_sprite = display.newSprite(pestSheet, sequenceData)
    self.pest_sprite.x = self.x
    self.pest_sprite.y = self.y

    self.base_sprite.alpha = 0
    self.base_sprite.isHitTestable = true

    self.elem_type = 'Pest'
    self.dying = false
end

function Pest:addSpritesToLayers()
    local layer = theField.layers[self.j]
    layer:insert(self.base_sprite)
    layer:insert(self.pest_sprite)
    layer:insert(self.weapon_sprite)
    layer:insert(self.overlay)
end

function Pest:move()
    self.pest_sprite.x = self.x
    self.pest_sprite.y = self.y
    FarmElement.move(self)
end

function Pest:onClick()
    if self:canClick() then
        print('--@Pest:onClick()')
        self:useWeapon()
        timer.performWithDelay(300, function() 
            theField:nextDay()
            self:useNext()
            end, 1)
    end
end

function Pest:spawn(type)
    if type == 'LazyGopher' then
        LazyGopher:spawn()
    elseif type == 'SmartGopher' then
        SmartGopher:spawn()
    elseif type == 'Crow' then
        Crow:spawn()
    else
        Cockatrice:spawn()
    end
end

function Pest:nextIsValid()
    print(self:whatIsNext().is_weapon)
    return self:whatIsNext().is_weapon
end

function Pest:die()
    if self.pest_sprite ~= nil then
        self.pest_sprite:removeSelf()
        self.overlay:removeSelf()
        self.base_sprite:removeSelf()
        self.base_sprite = nil
        self.pest_sprite = nil
        self.overlay = nil
    end
    self:removeFromField()
    self = nil
end

return Pest