function enable_touch(event)
    print('touches allowed again!')
    touchesAllowed = true
end

function onBasketTouch(self, event)
    print('on basket touch')
    if gameOver then
        return false
    end
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
