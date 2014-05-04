local Super = FarmElement
Pest = Class(Super)

function Pest:initialize(args)
    Super.initialize(self, args)
    self.elem_type = 'Pest'
end


function Pest:onClick()
    if self:canClick() then
        self:useWeapon()
        timer.performWithDelay(1200, function() 
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
    return self:whatIsNext().is_weapon
end

return Pest