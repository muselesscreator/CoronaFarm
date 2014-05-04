local Super = FarmElement
Blank = Class(Super)

function Blank:initialize(args)
    Super.initialize(self, args)
    self.elem_type = 'Blank'
    self.base_sprite.alpha = 0.5
    self.base_sprite.isHitTestable = true
    --print('===============')
    --    for i, v in pairs(theField.allElements) do
    --        print(v.id..'   i: '..v.i..'   j: '..v.j..' '..args.i..' '..args.j)
    --    end
    theField:addElement(self)
    self:addSpritesToLayers()
end

function Blank:onClick( event )
    if self:canClick() then
        print('can click')
        next = self:whatIsNext()
        if next.is_weapon then
            self:useWeapon()
            timer.performWithDelay(250, function() 
                    theField:nextDay()
                    self:useNext()
                end, 1)
        else
            self:toPlant()
            print('nextDay?')
            self:useNext()
            self:die()
            theField:nextDay()            
        end
        return true
    end
end

function Blank:removeFromField()
    for i, v in ipairs(theField.elements.Blank) do
        if v == self then
            table.remove(theField.elements.Blank, i)
        end
    end
end
--Done
function Blank:toPlant()
    local args = {i=self.i, j=self.j, type=self:whatIsNext().type}
    local tmp = Plant:new(args)
end

--Done
function Blank:nextIsValid()
    print('--@Blank: nextIsValid')
    return true
end
