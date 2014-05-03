require 'plants'
function enable_touch(event)
    print('touches allowed again!')
    touchesAllowed = true
end
function onSquareTap(self, event)
    if( not touchesAllowed ) then 
        print("can't touch this!")
        return true
    end

    if layers.popup.visible then
        return false
    end

    --don't allow touches for 1/2 a second
    --This is to avoid overlap in the Queue
    touchesAllowed = false
    timer.performWithDelay(500, enable_touch)
    local target  = event.target
    local phase   = event.phase
    local touchID = event.id
    local parent = self:square()
    local nextElement = {}


    print('--@onSquareTap: theQueue')
    for i, v in ipairs(theQueue) do
        print(i..' '..v.square_type)
    end

    print('==================================================================')
    print('==================================================================')
    print('--------------@onSquareTap: click registered')
    print('----------@onSquareTap: Square: '..self.id..' empty?')
    print(self.empty)

    if theBasket.box.selected then
        print('--@onSquareTap: use the box')
        nextElement = theBasket.box.type
    else
        print('--@onSquareTap: use the queue')
        nextElement = theQueue[1].square_type
    end
    local nextIsPlant = true
    if nextElement == 'Mallet' or nextElement == 'Slingshot' then
        nextIsPlant = false
    end
    clickedID = self.id
    -- If the clicked square is not a blocked square, and the options menu isn't up
    if not parent.blocked and layers.popup.visible == false then
        print('--@onSquareTap: not blocked and popup not visible')
        -- If it is an empty square
        if self.empty then
            print('--@onSquareTap: '..self.id..'  is empty')
            -- If you are placing a plant here
            if nextIsPlant then
                ------------------------------------------------------------
                --Event listener for key release
                --If the square is empty and the next entry in the queue
                --    is a plant
                --Add the next plant to this square, give it a stage and
                --    progress of 0 and set empty to false
                --Then, call the next-day function.
                ------------------------------------------------------------
                print("--@onSquareTap: placing a "..nextElement.." at "..self.id)
                self.isPlant=true
                getSquare(self.id):setImage(nextElement, 1)
            end
            if self.pest ~= false and self.pest.weapon == nextElement then
                if self.pest.myType == 'land' then
                    print('HAMMER DIE')
                    parent.weaponLayer:setSequence('seqGopherHammerDie')
                else
                    parent.weaponLayer:setSequence('seqSlingshot')
                end
                parent.weaponLayer.alpha = 1
                self.pest.dying = true
                parent.weaponLayer:play()
                local function kill()
                    self.pest:die()
                    parent.weaponLayer.alpha = 0
                end
                timer.performWithDelay(1200, kill, 1)
                timer.performWithDelay(100, function()
                    if theBasket.box.selected then
                        theBasket:empty()
                    else
                        theQueue:nextEntry()
                    end
                    theField:nextDay()                 
                    end, 1)
            end
            -- Nothing happens if you use a weapon on an empty square

            if theBasket.box.selected then
                theBasket:empty()
            else
                theQueue:nextEntry()
            end
            theField:nextDay()
        end
        -- Alright, so not blocked, menu isn't up, and it isn't empty
        -- If it also isn't barren
        if not self.empty then
            print('--@onSquareTap: not empty and not barren')
            --if it is a pest and you have the right weapon equipped
            print(self.pest)
            if self.pest ~= false then
                print(self.pest.weapon)
                print(nextElement)
                if self.pest.weapon == nextElement then
                    if self.pest.myType == 'land' then
                        print('HAMMER DIE')
                        parent.weaponLayer:setSequence('seqGopherHammerDie')
                        self.alpha = 0
                    else
                        parent.weaponLayer:setSequence('seqSlingshot')
                    end
                    parent.weaponLayer.alpha = 1
                    self.pest.dying = true
                    parent.weaponLayer:play()
                    self.pest:die()
                    if theBasket.box.selected then
                        theBasket:empty()
                    else
                        theQueue:nextEntry()
                    end
                    theField:nextDay()
                end
            end
            if self.pest == false or self.pest.myType == 'air' then
                if nextElement == 'Mallet' and self.myStage ~= Plants.mature and not self.isBarren then
                    print('--@onSquareTap: Mallet')
                    --Use the mallet to prune this square
                    --if self.myType~="Rock" then
                        print('--@onSquareTap: pruning')
                        print(self.id)
                        getSquare(self.id):clearImage()
                    --end
                    print(theBasket)
                    if theBasket.box.selected then
                        theBasket:empty()
                    else
                        theQueue:nextEntry()
                    end
                    theField:nextDay()
                elseif self.myStage==Plants.mature then
                    print("--@onSquareTap: harvest")
                    clickAction = "harvest"
                    theField:nextDay()
                    square = theField.first
                elseif self.myStage==Plants.rot then
                    print("--@onSquareTap: clear")
                    clickAction = "clear"
                    theField:nextDay()
                end
            end
        end
    end
    return true
end

function onBasketTouch(self, event)
    local target  = event.target
    local phase   = event.phase
    local touchID = event.id
    local parent  = self.parent

    if( not touchesAllowed or layers.popup.visible) then return true end
    if( target.isBase ) then return true end

    if( phase == "began" ) then
        display.getCurrentStage():setFocus( target, touchID )
        target.isFocus = true
    elseif( self.isFocus and phase == 'ended') then
        print('--------------@onBasketTouch: click registered')

        theBasket:respond()

        if( phase == "ended" or phase == "cancelled" ) then
            display.getCurrentStage():setFocus( nil )
            target.isFocus = false
        end
    end
    return true
end
