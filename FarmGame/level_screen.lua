local scene = storyboard.newScene()
local widget = require("widget")

storyboard.purgeOnSceneChange = true

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

local function gotoFarm()
    storyboard.gotoScene('farm_screen')
end

local function gotoTitle ()
   storyboard.gotoScene('title_screen')
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

    layers = display.newGroup()
    layers.bg = display.newGroup()
    layers.frame = display.newGroup()
    layers.scroll = display.newGroup()
    layers.overFrame = display.newGroup()
    layers.interface = display.newGroup()
    layers.popup = display.newGroup()

    layers:insert(layers.bg)
    layers:insert(layers.frame)
    layers:insert(layers.scroll)
    layers:insert(layers.overFrame)
    layers:insert(layers.interface)
    layers:insert(layers.popup)

    bg = display.newImage('images/fieldBackground.png')
    bg.anchorX = 0
    bg.anchorY = 0
    layers.bg:insert(bg)

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

    local tmpButton = widget.newButton
    {
        defaultFile = "images/sprites/tutorialHand.png",
        emboss = true,
        onRelease = gotoTitle
    }
    tmpButton.x = 120
    tmpButton.y = 90
    tmpButton.xScale = 1.5
    tmpButton.yScale = 1.5
    layers.interface:insert(tmpButton)

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

    layers.scroll:insert(scrollView)



    function onLevelTouch(self, event)
        if not info_up then
            local target  = event.target
            local phase   = event.phase
            local touchID = event.id
            local parent  = self.parent

            if( not touchesAllowed ) then return true end
            if( target.isBase ) then return true end


            print('my field')
            print(self.field)
            fieldType = self.field
            gotoFarm()

            return true
        end
    end

    function LevelSlide( self, event )
        if not info_up then
            if event.phase == "began" and not self.sliding then
                self.slide_event.start_time = event.time
                self.slide_event.start_x = event.x
            elseif event.phase == "moved" then
                if event.time > (self.slide_event.start_time+100) and not self.sliding then
                    if event.x < self.slide_event.start_x - 200 and self.target.index < self.target.levels then
                        self.sliding = true
                        self.target.index = self.target.index + 1
                        self.target:scrollToPosition
                        {
                            x = (1-self.target.index) * 500,
                            time = 800,
                        }
                        timer.performWithDelay(800, function() self.sliding = false end, 1)
                    elseif event.x > self.slide_event.start_x + 200 and self.target.index > 1 then
                        self.sliding = true
                        self.target.index = self.target.index - 1
                        self.target:scrollToPosition
                        {
                            x = (1-self.target.index) * 500,
                            time = 800,
                        }
                        timer.performWithDelay(800, function() self.sliding = false end, 1)
                    end
                end
            end
            return true
        else
            return true
        end
    end

    touch_interface = display.newRect(0, 0, w, h)
    touch_interface.alpha = 0
    touch_interface.isHitTestable = true
    touch_interface.anchorX = 0
    touch_interface.anchorY = 0
    touch_interface.touch = LevelSlide
    touch_interface.target = scrollView
    touch_interface.sliding = false
    touch_interface.slide_event = {}
    touch_interface:addEventListener("touch", touch_interface)
    print(touch_interface.target)
    layers.overFrame:insert(touch_interface)



    numFields = 0
    scrollView.fields = {}

    function infoTouch(self, event)
        if not info_up then
            print(self.type)
            info_boxes[self.type].alpha = 1
            return_buttons[self.type].alpha = 1
            info_up = true
            return true
        end
    end

    function hideInfo(self, event)
        self.alpha = 0
        info_boxes[self.type].alpha = 0
        info_up = false
        return true
    end

    info_boxes = {}
    return_buttons = {}
    info_buttons = {}
    info_up = false
    for i, myType in pairs(fields.order) do

        val = fields[myType]
        numFields = numFields + 1
        local thumb = {}
        newX = (numFields-1 )* 500 + 550

        fn = 'images/info'..myType..'Field.png'
        print(fn)
        info_boxes[myType] = display.newImage(fn)
        info_boxes[myType].x = display.contentWidth/2
        info_boxes[myType].y = display.contentHeight/2
        info_boxes[myType].alpha = 0

        return_buttons[myType] = display.newImage('images/returnMenuButton.png')
        return_buttons[myType].x = 720
        return_buttons[myType].y = 275
        return_buttons[myType].xScale = .7
        return_buttons[myType].yScale = .7
        return_buttons[myType].alpha = 0
        return_buttons[myType].tap = hideInfo
        return_buttons[myType]:addEventListener('tap', return_buttons[myType])
        return_buttons[myType].type = myType
        layers.popup:insert(info_boxes[myType])
        layers.popup:insert(return_buttons[myType])


        if thePlayer.totalScore >= val.minScore then

            thumb = display.newImage(val.thumb)
            thumb.tap = onLevelTouch
            thumb:addEventListener("tap", thumb )

            print(newX)
            print(tostring(thePlayer.highScores[myType]))

            local scorecard = display.newImage('images/scorebar2.png')
            scorecard.x = newX
            scorecard.y = 183
            scrollView:insert(scorecard)
            local txt = display.newText(tostring(thePlayer.highScores[myType]), newX, 200, nil, 33)
            txt:setFillColor(.7, .7, 0)
            scrollView:insert(txt)
            txt = display.newText(tostring(thePlayer.highScores[myType]), newX, 200, nil, 35)
            txt:setFillColor(.2, .2, 1)
            scrollView:insert(txt)
            txt = display.newText('High Score:', newX, 170, nil, 30)
            txt:setFillColor(0, .5, 0)
            scrollView:insert(txt)
            scrollView:insert(thumb)

        else

            thumb = display.newImage(val.thumb_dis)
            scrollView:insert(thumb)
            local txt = display.newText(tostring(val.minScore), newX, 510, nil, 50)
            scrollView:insert(txt)
            txt = display.newText('To unlock', newX, 550, nil, 50)
            scrollView:insert(txt)

        end
        info_buttons[myType] = display.newImage('images/questionMenuButton.png')
        info_buttons[myType].x = newX
        info_buttons[myType].y = 680
        info_buttons[myType].type = myType
        info_buttons[myType].tap = infoTouch
        info_buttons[myType]:addEventListener('tap', info_buttons[myType])
        scrollView:insert(info_buttons[myType])





        thumb.anchorX = 0
        thumb.y = display.contentHeight/2+40
        thumb.xScale = .8
        thumb.yScale = .8
        thumb.field = myType
        thumb.x = (numFields-1)*500 +350
        scrollView.fields[i] = thumb
        print('add thumb')
        print(val.thumb)
    end
    scrollView.index = 1
    scrollView.levels = numFields
    scrollView:setScrollWidth((numFields * 500) + 950)

    group:insert(layers)
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
