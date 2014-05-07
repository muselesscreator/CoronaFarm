
FarmElement = Class()

function FarmElement:initialize(args)
    self.i = args.i
    self.j = args.j
    self:deriveXY()
    print(args.i)
    local function onClick(event)

        local target  = event.target
        local phase = event.phase
        
        if touchesAllowed and not layers.popup.visible and not gameOver then

            local pest = theField:pestAt(self.i, self.j)
            if pest ~= false then
                if pest:canClick() then
                    print('CLICK ON PEST')
                    touchesAllowed = false
                    timer.performWithDelay(500, function() touchesAllowed = true end, 1)
                    pest:onClick(event)
                    return true
                end
            end           
            if self:canClick() then
                touchesAllowed = false
                timer.performWithDelay(500, function() touchesAllowed = true end, 1)
                self:onClick(event)
                return true
            end
        end
    end

    local base_sprite = display.newSprite(myImageSheet, sequenceData)
    base_sprite:setSequence('seqBlank')
    base_sprite.x = self.x 
    base_sprite.y = self.y
    base_sprite.tap = onClick
    base_sprite:addEventListener('tap', onClick)


    local overlay = display.newSprite(myImageSheet, sequenceData)
    overlay:setSequence('seqBlank')
    overlay.x = self.x
    overlay.y = self.y
    overlay.alpha = 0

    draw_priority = 0 --1 and up are drawn (1 first)

    self.base_sprite = base_sprite
    self.overlay = overlay
end


function FarmElement:deriveXY()
    self.x = theField.X + (self.i-1)*((theField.W/theField.columns))
    self.y = theField.Y + (self.j-1)*((theField.H/theField.rows))   
end

function FarmElement:addSpritesToLayers()
    local layer = theField.layers[self.j]
    layer:insert(self.base_sprite)
    layer:insert(self.overlay)
end

function FarmElement:move()
    self.base_sprite.x = self.x
    self.base_sprite.y = self.y
    self.overlay.x = self.x
    self.overlay.y = self.y
end

--Done
function FarmElement:getNeighbors()
    print('--@FarmElement:getNeighbors')
    local neighbors = {above=nil, below=nil, right=nil, left=nil}
    if self.i > 1 then
        neighbors.left = theField:whatIsAt(self.i-1, self.j)
    end
    if self.i < theField.columns then
        neighbors.right = theField:whatIsAt(self.i+1, self.j)
    end    
    if self.j > 1 then
        neighbors.above = theField:whatIsAt(self.i, self.j-1)
    end
    if self.j < theField.rows then
        neighbors.below = theField:whatIsAt(self.i, self.j+1)
    end
    return neighbors
end
--Done
function FarmElement:nextDay()
    return true
end
--Done
function FarmElement:onClick( event )
    if self.elem_type == 'Blank' then
        return Blank:onClick( event )
    end
    return false
end
--Done
function FarmElement:nextDay()
    print('--@FarmElement:nextDay()')
    return true
end
--Done
function FarmElement:die()
    print('FarmElement:die')
    if self.base_sprite ~= nil then
        self.base_sprite:removeSelf()
        self.overlay:removeSelf()
        self.base_sprite = nil
        self.overlay = nil
    end
    self:removeFromField()
    self = nil
end

--Done
function FarmElement:whatIsNext()
    if theBasket.box.selected then
        return theBasket.box.contents
    else
        return theQueue[1].contents
    end
end
--Done
function FarmElement:useNext()
    if theBasket.box.selected then
        theBasket:empty()
    else
        theQueue:nextEntry()
    end
end
--Done
function FarmElement:nextIsValid()
    print('--@FarmElement:nextIsValid')
    return false
end
--Done
function FarmElement:canClick()
    print('--@FarmElement:canClick()')
    return self:nextIsValid()
end

--Done?
function FarmElement:addToField()
    theField.elements[self.elem_type][#theField.elements[self.elem_type]+1] = self
end
--Done
function FarmElement:removeFromField()
    print('--@FarmElement:removeFromField')
    for i, v in ipairs(theField.elements[self.elem_type]) do
        if v == self then
            table.remove(theField.elements[self.elem_type], i)
        end
    end
end
--Done
function FarmElement:useWeapon()
    self.base_sprite:setSequence('seq'..self:whatIsNext().type)
    self.base_sprite:play()
    timer.performWithDelay(250, function()
        self.base_sprite.alpha = 0 
        self.base_sprite:setSequence('seqBlank')
        end, 1)
end


function FarmElement:hide()
    self.base_sprite.alpha = 0
    self.overlay.alpha = 0
end

function FarmElement:show()
    self.base_sprite.alpha = 1
end
