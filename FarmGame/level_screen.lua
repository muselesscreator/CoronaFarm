local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")

----------------------------------------------------------------------------------
--
--      NOTE:
--
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local screenGroup = self.view

    bg = display.newImage('images/fieldBackground.png')
    bg.anchorX = 0
    bg.anchorY = 0
    screenGroup:insert(bg)

    -- Our ScrollView listener
    local function scrollListener( event )
        local phase = event.phase
        local direction = event.direction

        if "began" == phase then
            --print( "Began" )
        elseif "moved" == phase then
            --print( "Moved" )
        elseif "ended" == phase then
            --print( "Ended" )
        end

        -- If the scrollView has reached it's scroll limit
        if event.limitReached then
            if "up" == direction then
                print( "Reached Top Limit" )
            elseif "down" == direction then
                print( "Reached Bottom Limit" )
            elseif "left" == direction then
                print( "Reached Left Limit" )
            elseif "right" == direction then
                print( "Reached Right Limit" )
            end
        end

        return true
    end

    -- Create a ScrollView
    local scrollView = widget.newScrollView
    {
        left = 0,
        top = 0,
        width = display.contentWidth,
        height = display.contentHeight,
        anchorX = 0,
        anchorY = 0,
        --scrollWidth = 1500,
        hideBackground = true,
        id = "onBottom",
        horizontalScrollDisabled = false,
        verticalScrollDisabled = true,
        listener = scrollListener,
    }

    screenGroup:insert(scrollView)

    function onLevelTouch(self, event)
        local target  = event.target
        local phase   = event.phase
        local touchID = event.id
        local parent  = self.parent

        if( not touchesAllowed ) then return true end
        if( target.isBase ) then return true end


        print('my field')
        print(self.field)
        fieldType = self.field
        storyboard:gotoScene('farm_screen')

        return true
    end

    numFields = 0

    for i, val in pairs(fields) do
        if thePlayer.totalScore >= val.minScore then
            numFields = numFields + 1
            thumb = display.newImage(fields[i].thumb)
            thumb.anchorX = 0
            thumb.y = display.contentHeight/2
            thumb.field = i
            thumb.tap = onLevelTouch
            thumb:addEventListener("tap", thumb )
            thumb.x = (numFields-1)*600 +300
            screenGroup:insert(thumb)
            scrollView:insert(thumb)
            print('add thumb')
            print(fields[i].thumb)
        end
    end
    scrollView:setScrollWidth((numFields * 600) + 450)

end

--  BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)

        -----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

        -----------------------------------------------------------------------------

end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

return scene
