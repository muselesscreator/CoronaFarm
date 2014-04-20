local storyboard = require( "storyboard" )
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


-- local forward references should go here --

local function gotoFarm()
    storyboard.gotoScene('farm_screen')
end

local function gotoLevel()
    storyboard.gotoScene('level_screen')
end

local function gotoTutorial()
    storyboard.gotoScene('tutorial_screen')
end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
    print("title_screen")
    local screenGroup = self.view

    bg = display.newImage('images/fieldBackground.png')
    bg.anchorX = 0
    bg.anchorY = 0
    screenGroup:insert(bg)

    text1 = display.newText( "Farmaggedon!", 0, 0, CustomFont, 50 )
    text1:setTextColor( 255 )
    text1.x, text1.y = display.contentWidth * 0.5, 300
    screenGroup:insert( text1 )
    local FarmButton = widget.newButton
    {
        defaultFile = "images/buttonRed.png",
        overFile = "images/buttonRedOver.png",
        label = "Farm Now",
        emboss = true,
        onRelease = gotoFarm,
    }
    FarmButton.x = display.contentWidth * 0.5
    FarmButton.y = 370
    screenGroup:insert(FarmButton)

    local LevelButton = widget.newButton
    {
        defaultFile = "images/buttonRed.png",
        overFile = "images/buttonRedOver.png",
        label = "Level Select",
        emboss = true,
        onRelease = gotoLevel,
    }
    LevelButton.x = display.contentWidth * 0.5
    LevelButton.y = 450
    screenGroup:insert(LevelButton)

    local TutorialButton = widget.newButton
    {
        defaultFile = "images/buttonRed.png",
        overFile = "images/buttonRedOver.png",
        label = "Play Tutorial",
        emboss = true,
        onRelease = gotoTutorial,
    }
    TutorialButton.x = display.contentWidth * 0.5
    TutorialButton.y = 530
    screenGroup:insert(TutorialButton)

    timer.performWithDelay(10, function() touchesAllowed = true end)

end


-- Called BEFORE scene has moved onscreen:
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
