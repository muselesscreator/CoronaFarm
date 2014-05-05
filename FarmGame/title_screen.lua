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
    if not layers.popup.visible then
        storyboard.gotoScene('farm_screen')
    end
end

local function gotoLevel()
    if not layers.popup.visible then
        storyboard.gotoScene('level_screen')
    end
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
    group = self.view

    layers = display.newGroup()

    layers.bg = display.newGroup()
    bg = display.newImage('images/fieldBackground.png')
    bg.anchorX = 0
    bg.anchorY = 0
    layers.bg:insert(bg)

    local logo = display.newImage('images/farmLogo.png')
    logo.x = display.contentWidth/2
    logo.y = 300
    logo.xScale = 1.8
    logo.yScale = 2.2
    layers.bg:insert(logo)

    layers.frame = display.newGroup()
    local FarmButton = widget.newButton
    {
        defaultFile = "images/playNow.png",
        overFile = "images/playNowDown.png",
        emboss = true,
        onRelease = gotoFarm,
    }
    FarmButton.x = display.contentWidth * 0.5
    FarmButton.y = 470
    FarmButton.xScale = 1.5
    FarmButton.yScale = 1.5
    layers.frame:insert(FarmButton)

    local LevelButton = widget.newButton
    {
        defaultFile = "images/levelSelect.png",
        overFile = "images/levelSelectDown.png",
        emboss = true,
        onRelease = gotoLevel,
    }
    LevelButton.x = display.contentWidth * 0.5
    LevelButton.y = 580
    LevelButton.xScale = 1.5
    LevelButton.yScale = 1.5
    layers.frame:insert(LevelButton)
    
    local tmpButton = widget.newButton
    {
        defaultFile = "images/popOutMenuButton.png",
        emboss = true,
        onRelease = toggleOptions
    }
    tmpButton.x = 930
    tmpButton.y = 700
    layers.frame:insert(tmpButton)

    layers.popup = display.newGroup()
    layers:insert(layers.popup)

    local popupMenu = display.newImageRect( layers.popup, "images/popOutMenuBase.png", 534, 382)
    popupMenu.x = 200
    popupMenu.y = 200
    popupMenu.anchorX = 0
    popupMenu.anchorY = 0
    layers.popup.visible = false

    local exitButton = widget.newButton
    {
        defaultFile = "images/buttonEx.png",
        overFile = "images/buttonEx.png",
        emboss = true,
        onRelease = toggleOptions
    }
    exitButton.x = 690
    exitButton.y = 250
    exitButton.xScale = .7
    exitButton.yScale = .7
    layers.popup:insert(exitButton)

    local txt = display.newText(layers.popup, 'Music Volume', 470, 320, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local mscSlider = VolSlider({x = 300, y=340, w=350, h=55, range=100, startX = musicVolume, event='setMusicVolume'})
    mscSlider.icon:addEventListener('setMusicVolume', setMusicVolume)
    
    txt = display.newText(layers.popup, 'Sound-Effects Volume', 470, 450, native.systemFontBold, 25)
    txt:setFillColor(0, 0, 0)
    local sfxSlider = VolSlider({x = 300, y=480, w=350, h=55, range=100, startX = sfxVolume, event='setSFXVolume'})
    sfxSlider.icon:addEventListener('setSFXVolume', setSFXVolume)

    layers.popup.alpha = 0



    group:insert(layers.bg)
    group:insert(layers.frame)
    group:insert(layers.popup)
    timer.performWithDelay(10, function() touchesAllowed = true end)

    tmpImage = display.newImage('images/plus.png')
    tmpImage.x = 100
    tmpImage.y = 75
    tmpImage.alpha = .3
    layers.frame:insert(tmpImage)
    tmpImage.touch = promote_player
    tmpImage:addEventListener('touch', tmpImage)

    tmpImage = display.newImage('images/minus.png')
    tmpImage.x = 900
    tmpImage.y = 75
    tmpImage.alpha = .3
    layers.frame:insert(tmpImage)
    tmpImage.touch = clear_player
    tmpImage:addEventListener('touch', tmpImage)

end

function clear_player(self, event)
    thePlayer.id = 0
    thePlayer.levelScore = 0
    thePlayer.totalScore = 0
    thePlayer.highScores = {Salad = 0,Stew = 0,Salsa = 0,Tea = 0}
    thePlayer.has_played_level = {false, false, false, false}
    saveTable(thePlayer, 'player.json')
end

function promote_player(self, event)
    thePlayer.id = 0
    thePlayer.levelScore = 0
    thePlayer.totalScore = 25000
    thePlayer.highScores = {Salad = 0,Stew = 0,Salsa = 0,Tea = 0}
    thePlayer.has_played_level = {false, false, false, false}
    saveTable(thePlayer, 'player.json')
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
