require 'class'
require 'libField'
require 'plants'
local bezier = require 'bezier'
local storyboard = require 'storyboard'
storyboard.purgeOnSceneChange = true
local widget = require("widget")
tutorials = {}

tutorials.Salad = {
    level = {fieldType ='Salad'},
    first_scene = 'SaladWelcome',
    initial_queue = {'Radish', 'Radish', 'Radish'},
}
function runTutorial(fieldType)
    level = tutorials[fieldType].level
    scenes = tutorials[fieldType].scenes
    scene = 0
    TutorialScene(tutorials[fieldType].first_scene)

end



function nextButton(fn)
    if level.next ~= nil then
        level.next:removeSelf()
        level.next = nil
    end
    if fn == nil then
        return false
    end
    local tmpButton = widget.newButton
    {
        defaultFile = "images/sprites/arrow-right.png",
        emboss = true,
        onRelease = function() 
            if touchesAllowed then
                TutorialScene(fn) 
            end
        end
    }
    tmpButton.x = 950
    tmpButton.y = 700
    tmpButton.width=75
    tmpButton.height=75
    layers.tutorial:insert(tmpButton)
    level.next = tmpButton
end
function setupScene(args)
    print(args.nextFunction)
    touchesAllowed = false
    print(args.length)
    timer.performWithDelay(args.length+50, function() touchesAllowed = true end, 1)
    if args.nextFunction == nil then
        nextButton()
    else
        print(args.nextFunction)
        nextButton(args.nextFunction)
    end
end
function TutorialScene()
    scene = scene + 1
    if scene == 1 then
        theQueue.weights = {Radish=100}
        level.hand1 = tutorialPointer(450, 450)
        level.hand1:rotate(225)
        level.text1 = textBox(300, 300, 700, 100, "Click to plant the seeds in your basket", 25)
        level.plant1 = plantObject(2, 4, 'Blank', 1)
        level.plant1.sprite.alpha = .01
        level.plant1:addListener(makeRadish)
    elseif scene == 2 then
        level.plant1.sprite:removeEventListener('tap', level.plant1.sprite)
        level.plant1:changeTo('Radish', 1)
        level.plant1:show()
        theQueue:stackedNextEntry()
        level.hand1:BounceTo(3, 4)
        level.plant2 = plantObject(3, 4, 'Blank', 1)
        level.plant2.sprite.alpha = .01
        level.plant2:addListener(makeRadish)
    elseif scene == 3 then
        level.plant2.sprite:removeEventListener('tap', level.plant2.sprite)
        level.plant2:changeTo('Radish', 1)
        level.plant2:show()
        theQueue:stackedNextEntry()
        level.hand1:BounceTo(3, 5)
        level.plant3 = plantObject(3, 5, 'Blank', 1)
        level.plant3.sprite.alpha = .01
        level.plant3:addListener(makeRadish)
    end
end

function makeRadish(self, event)
    print("?")
    print(self:plant().id)
    self:plant():changeTo('Radish', 0)
    TutorialScene()
    return true
end

function MoveCircle(object, r, depth, time)
    local x1 = object.x
    local x2 = x1 + r / 2
    local x3 = x1 + r
    local y1 = object.y
    local y2 = y1 + r / 2
    local y3 = y1 - r
    local curve = bezier:curve({x1, x2, x3, x2, x1}, {y1, y2, y1, y3, y1})
    MoveInCurve(object, curve, depth, time)
end

function CurveBounce(object, xDiff, bounce, depth, time)
    print('--@CurveBounce')
    local x1 = object.x; x3 = object.x + xDiff; x2 = (x1+x3)/2
    local y1 = object.y; y2 = y1-bounce 
    local curve = bezier:curve({x1, x2, x3}, {y1, y2, y1})
    MoveInCurve(object, curve, depth, time)
end

function CurveStep(sprite, curve, step, wait)
    local i = stepNum*step
    stepNum = stepNum + 1
    local x, y = curve(i)
    print(x..' '..y)
    sprite.x = x
    sprite.y = y
end

function MoveInCurve(sprite, curve, depth, time)
    step = 1/(depth)
    wait = time/(depth+2)
    print('--@MoveInCurve: wait= '..wait)
    stepNum = 0
    timer.performWithDelay(wait, function() CurveStep(sprite, curve, step, wait) end, depth+1)
end

plantObject = class(function(plant, i, j, type, frame)
    plant.x = theField.grid[i][j].x
    plant.y = theField.grid[i][j].y
    plant.i = i
    plant.j = j
    plant.id = i..','..j
    plant.stage = frame
    local sprite = newSprite('seq'..type, plant.x, plant.y)
    sprite:setFrame(frame)

    local decorator = newSprite('seqBlank', plant.x, plant.y)
    if frame == 4 then
        decorator:setSequence('seqTag')
    elseif frame == 5 then
        decorator:setSequence('seqSmell')
        decorator:play()
    else
        decorator.alpha = 0
    end
    layers.field:insert(sprite)
    layers.field:insert(decorator)
    plant.sprite = sprite
    plant.decorator = decorator 
    function sprite:plant()
        return plant
    end
    return plant
    end)

function plantObject:moveTo(i, j)
    self.i = i
    self.j = j
    self.x = theField.grid[i][j].x
    self.y = theField.grid[i][j].y
    self.sprite.x = self.x
    self.sprite.y = self.y
    self.decorator.x = self.x
    self.decorator.y = self.y
end

function plantObject:changeTo(type, frame)
    print(type)
    print(frame)
    self.stage = frame
    print('==============')
    self.sprite:setSequence('seq'..type)
    self.sprite:setFrame(frame)
    if frame == 4 then
        self.decorator:setSequence('seqTag')
        self.decorator.alpha = 1
    elseif frame == 5 then
        self.decorator:setSequence('seqSmell')
        self.decorator:play()
        self.decorator.alpha = 1
    else
        self.decorator.alpha = 0
    end
end

function plantObject:hide()
    self.sprite.alpha = 0
    self.decorator.alpha = 0
end

function plantObject:show()
    self.sprite.alpha = 1
    if self.stage == 4 or self.stage == 5 then
        self.decorator.alpha = 1
    else
        self.decorator.alpha = 0
    end
end

function plantObject:die()
    self.sprite:removeSelf()
    self.sprite = nil
    self.decorator:removeSelf()
    self.decorator = nil
    self = nil
end

function plantObject:addListener(f)
    self.sprite.tap = f
    self.sprite:addEventListener('tap', self.sprite)
end

function plantObject:harvest(score, multiplier)
    local multiplier = multiplier or false
    local star = newSprite('seqScoreStar', self.x, self.y)
    local mult = {}
    layers.field:insert(star)
    star.width = 25
    star.heigh = 25
    transition.to(star, {y=self.y - 100, width = 85, height = 85, alpha=.8, time=100})
    local function score(stage)
        if stage == 1 then
            transition.to(star, {width = 150, height=150, alpha = 0, time=300})
            local score = display.newText('1', self.x+115, self.y+5, 250, 250, gameFont, 35)
            score:setFillColor(.3, .3, .8)
            score.alpha = .8
            transition.to(score, {width=300, height=300, size=35, alpha=0, time=200})
            if multiplier then
                mult = display.newText(multiplier, self.x+175, self.y-150, 250, 250, gameFont, 35)
                mult:setFillColor(.3, .3, .8)
                mult.alpha = .8
                mult.size=45
                mult:rotate(-45)
                transition.to(mult, {width=300, height=300, size=45, alpha=0, time=300})
            end
            self:hide()
            timer.performWithDelay(350, function()
                    star:removeSelf()
                    star = nil
                    score:removeSelf()
                    score = nil
                    if multiplier then
                        mult:removeSelf()
                        mult = nil
                    end
                end, 1)
        end
    end
    timer.performWithDelay( 250, function() score(1) end, 1 )
end

textBox = class(function(textbox, x, y, w, h, content, padding)
    textbox.x = x
    textbox.y = y
    textbox.w = w
    textbox.h = h
    textbox.content = content
    local img = display.newImageRect('images/tutorialBox.png', x, y)
    img.x = x
    img.y = y
    img.width = w
    img.height = h
    img.anchorX = 0
    img.anchorY = 0
    layers.overFrame:insert(img)
    textbox.img = img
    local txt = display.newText(content, x+padding, y+padding, w-2*padding, h-padding*2, gameFont, 30)
    txt.anchorX = 0
    txt.anchorY = 0
    txt.align = "center"
    txt:setFillColor(0, 0, 0)
    layers.overFrame:insert(txt)    
    textbox.txt = txt
    return textbox
    end)

function textBox:setText(content)
    self.txt.text = content
end

function textBox:move(options)
    local text_options = {}
    for i, v in pairs(options) do
        if i == 'x' then
            text_options.x = v + 25
        elseif i == 'y' then
            text_options.y = v + 25
        elseif i == 'width' then
            text_options[i] = v-50
        elseif i == 'height' then
            text_options[i] = v-50
        else
            text_options[i] = v
        end
    end
    transition.to(self.txt, text_options)
    self.txt.text = self.txt.text
    transition.to(self.img, options)
end

function textBox:die()
    self.img:removeSelf()
    self.txt:removeSelf()
    self = nil
end

tutorialPointer = class(function(hand, x, y)
    hand.x = x
    hand.y = y
    hand.sprite = newSprite('seqTutorialHand', x, y)
    hand.orientation = 0
    hand.flip = false
    return hand
    end)

function tutorialPointer:rotate(new_rotation)
    self.sprite:rotate(-self.orientation)
    self.sprite.xScale = 1
    self.flipped = false
    self.orientation = 0
    if new_rotation > 90 and new_rotation < 270 then
        self.sprite.xScale = -1
        self.flipped = true        
        self.sprite:rotate(new_rotation - 180)
        self.orientation = new_rotation - 180
    else
        self.sprite:rotate(new_rotation)
        self.orientation = new_rotation
    end
end

function tutorialPointer:die()
    self.sprite:removeSelf()
    self = nil
end

function tutorialPointer:BounceTo(i, j)
    local x1 = self.x
    local x3 = theField.grid[i][j].x-50
    print(self.flipped)
    if not self.flipped then
        x3 = x3+100
    else
        x3 = x3
    end
    local x2 = math.floor((x1+x3)/2)
    local y1 = self.y
    local y3 = theField.grid[i][j].y-50
    local y2 = math.floor((y1+y3)/2-100)
    self.x = x3
    self.y = y3
    local curve = bezier:curve({x1, x2, x3}, {y1, y2, y3})
    MoveInCurve(self.sprite, curve, 10, 250)
end

function tutorialPointer:BounceToXY(x, y)
    local x1 = self.x
    local x3 = x
    local x2 = math.floor((x1+x3)/2)
    local y1 = self.y
    local y3 = y
    local y2 = math.floor((y1+y3)/2-100)
    self.x = x3
    self.y = y3
    local curve = bezier:curve({x1, x2, x3}, {y1, y2, y3})
    MoveInCurve(self.sprite, curve, 10, 250)
end

tutorialGopher = class(function(gopher, i, j)
    gopher.i = i
    gopher.j = j
    gopher.x = theField.grid[i][j].x
    gopher.y = theField.grid[i][j].y
    local sprite = newSprite('seqGopher', gopher.x, gopher.y)
    layers.field:insert(sprite)
    sprite:play()
    gopher.sprite = sprite
    return gopher
    end)

function tutorialGopher:moveTo(i, j)
    self.x = theField.grid[i][j].x
    self.y = theField.grid[i][j].y
    self.i = i
    self.j = j
    self.sprite:setSequence('seqGopherOut')
    self.sprite:play()
    timer.performWithDelay(300, function() 
        self.sprite.x = self.x
        self.sprite.y = self.y
        self.sprite:setSequence('seqGopher')
        self.sprite:play()
        end, 1)
end

function tutorialGopher:eat(plant)
    self:moveTo(plant.i, plant.j)
    timer.performWithDelay(50, function() plant:die() end, 1)
end

function tutorialGopher:delete()
    self.sprite:removeSelf()
    self.sprite = nil
    self = nil
end

function tutorialGopher:die()
    local hammer = newSprite('seqMallet', self.x-100, self.y-100)
    hammer:play()
    local function kill()
        self.sprite:setSequence('seqGopherDie')
        self.sprite:play()
        hammer:removeSelf()
        hammer = nil
        timer.performWithDelay(800, function()
                self.sprite:removeSelf()
                rock = newSprite('seqRock', self.x, self.y)
                self.sprite = rock
                layers.field:insert(rock)
            end, 1)
    end
    timer.performWithDelay(300, function() kill() end, 1)
end