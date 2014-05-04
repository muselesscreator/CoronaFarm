local storyboard = require 'storyboard'

Basket = class(function(basket)

        local box = display.newSprite(myImageSheet, sequenceData)
        box:setSequence("seqBoxClosed")
        box.alpha = 1
        box.x = theField.Basket.X
        box.y = theField.Basket.Y
        box.touch = onBasketTouch
        box:addEventListener("touch", box)
        layers.frame:insert(box)
        basket.box = box

        local decorator = display.newSprite(myImageSheet,
            sequenceData)
        decorator:setSequence("seqBlank")
        decorator.alpha = .01
        decorator.x = theField.Basket.X + 15
        decorator.y = theField.Basket.Y + 5
        decorator.height = 50
        decorator.width = 50
        layers.frame:insert(decorator)
        basket.decorator = decorator

        basket.box.parent = basket
        basket.box.empty = true
        basket.box.selected = false
        basket.box.type = nil
        basket.box.contents = {}
    end)

function Basket:fill()
    local sprite = self.decorator
    local contents = theQueue[1].contents

    sprite:setSequence("seq"..contents.type)
    sprite:setFrame(1)
    sprite.alpha = 1

    self.box.empty = false
    self.box.selected = false
    self.box.contents = contents
    theQueue:nextEntry()

    theField:chkGameOver()

end

function Basket:select()
    local sprite = self.decorator
    local box = self.box
    if box.selected then
        box:setSequence('seqBoxClosed')
        box.selected = false
    else
        box:setSequence('seqBoxOpen')
        box.selected = true
    end
end

function Basket:empty(square)
    print('empty')
    self.box:setSequence('seqBoxClosed')
    self.decorator:setSequence('seqBlank')
    self.decorator.alpha = .2
    self.box.empty = true
    self.box.selected = false
    self.box.contents = {}
end

function Basket:respond()
    if self.box.empty then
        print('fill')
        self:fill()
    else
        print('select')
        self:select()
    end
end
