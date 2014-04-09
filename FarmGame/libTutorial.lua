require 'class'
require 'libField'
require 'plants'
local bezier = require 'bezier'
local storyboard = require 'storyboard'
local widget = require("widget")
tutorials = {}

tutorials.Salad = {
    level = {fieldType ='Salad'},
    scenes = 
        {
            'SaladWelcome'
        },
    initial_queue = {'Radish', 'Radish', 'Radish'},
    initial_weights = {Mallet=100}
}

function runTutorial(fieldType)
    level = tutorials[fieldType].level
    scenes = tutorials[fieldType].scenes
    for i, step in ipairs(scenes) do
        TutorialScene('SaladWelcome')
    end
end

function newSprite(sequence, x, y)
    sprite = display.newSprite(myImageSheet, sequenceData)
    sprite:setSequence(sequence)
    sprite.x = x
    sprite.y = y
    return sprite
end



function nextButton(fn)
    if level.next ~= nil then
        level.next:removeSelf()
        level.next = nil
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

function TutorialScene(scene)
    if scene == 'SaladWelcome' then
        level.hand1 = hand1
        textbox1 = textBox(300, 50, 700, 100, 'Welcome to the world of Farmageddon!', 25)
        level.textbox1 = textbox1
        level.text1 = text1
        nextButton('SaladWelcome1')
    elseif scene == 'SaladWelcome1' then
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 175, "Our last line of defense against a global pest crisis is your ability to farm epic produce combos.", 25)
        nextButton('SaladWelcomeField')
    elseif scene == 'SaladWelcomeField' then
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 250, "This is your field.\nDifferent fields are suitable for growing different types of crops.\nThis field is suitable for growing Radishes and Lettuce.", 25)
        level.hand1 = tutorialPointer(475, 450)
        layers.tutorial:insert(level.hand1.sprite)
        level.hand1:rotate(140)
        MoveCircle(level.hand1.sprite, 400, 20, 600)
        nextButton('SaladWelcomeQueue')
    elseif scene == 'SaladWelcomeQueue' then
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 125, "This is your product queue - Currently stacked with plenty of Radish seeds.", 25)
        level.hand1:rotate(30)
        transition.to(level.hand1.sprite, {x=270, y=240, time=200})
        level.hand1.x = 475
        level.hand1.y = 450
        level.textbox2 = textBox(300, 350, 350, 70, '*This is the next item up.', 10)
        level.textbox2.txt.size = 30
        level.hand2 = tutorialPointer(270, 450)
        level.hand2:rotate(330)
        level.hand2.sprite.xScale = .8
        level.hand2.sprite.yScale = .8
        nextButton('SaladPlanting1')
    elseif scene == 'SaladPlanting1' then
        level.hand2:die()
        level.textbox2:die()
        level.hand1:rotate(225)
        transition.to(level.hand1.sprite, {x=300, y=475, time=200})
        level.textbox1:setText("Tap an empty plot of land to plant the seeds next up in the queue.")
        nextButton('SaladPlanting2')
    elseif scene == 'SaladPlanting2' then
        level.textbox1:setText("...and the rest of the items in the queue will drop down for use.")
        local curve = bezier:curve({300, 250, 325}, {475, 400, 450})
        MoveInCurve(level.hand1.sprite, curve, 5, 250)
        timer.performWithDelay(150, function()
                level.plant1 = plantObject(1, 4, 'Seeds', 1)
                theQueue.weights = {Radish=100}
                theQueue:stackedNextEntry()
                level.hand2 = tutorialPointer(275, 175)
            end, 1)
        nextButton('SaladPlanting3')
    elseif scene == 'SaladPlanting3' then
        level.hand2:die()
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 125, "As you continue to plant new seeds, your older plants will grow by a day per turn.", 15)
        level.hand1.x = level.hand1.sprite.x
        level.hand1.y = level.hand1.sprite.y
        level.hand1:BounceTo(2, 4)
        local function planting(stage)
            if stage == 1 then
                theQueue:stackedNextEntry()
                level.plant1:changeTo('Radish', 1)
                level.plant2 = plantObject(2, 4, 'Seeds', 1)
                level.hand1:BounceTo(3, 4)
                timer.performWithDelay(400, function() planting(2) end, 1)
            elseif stage == 2 then
                theQueue:stackedNextEntry()
                level.plant1:changeTo('Radish', 2)
                level.plant2:changeTo('Radish', 1)
                level.plant3 = plantObject(3, 4, 'Seeds', 1)
                level.hand1:BounceTo(4, 4)
                timer.performWithDelay(400, function() planting(3) end, 1)
            elseif stage == 3 then
                theQueue:stackedNextEntry()
                level.plant1:changeTo('Radish', 3)
                level.plant2:changeTo('Radish', 2)
                level.plant3:changeTo('Radish', 1)
                level.plant4 = plantObject(4, 4, 'Seeds', 1)
            end
        end
        timer.performWithDelay(400, function() planting(1) end, 1)
        nextButton('SaladPlanting4')
    elseif scene == 'SaladPlanting4' then
        level.textbox1:setText("If plants are left unattended for too long, they will wither and rot.")
        level.hand1:BounceTo(5, 4)
        local function planting(stage)
            if stage == 1 then
                theQueue:stackedNextEntry()
                level.plant1:changeTo('Radish', 4)
                level.plant2:changeTo('Radish', 3)
                level.plant3:changeTo('Radish', 2)
                level.plant4:changeTo('Radish', 1)
                level.plant5 = plantObject(5, 4, 'Seeds', 1)
            end
        end
        timer.performWithDelay(400, function() planting(1) end, 1)
        nextButton('SaladHarvest1')
    elseif scene == 'SaladHarvest1' then
        level.textbox1:setText("Be sure to harvest mature plants before that happens by tapping them.")
        level.hand1:rotate(315)
        level.hand1:BounceTo(2, 4)
        local function harvest(stage)
            if stage == 1 then
                level.plant2:harvest()
                scoreHUD.text = 1
            end
        end
        timer.performWithDelay( 400, function() harvest(1) end, 1 )
        nextButton('SaladHarvest2')
    elseif scene == 'SaladHarvest2' then
        level.textbox1:setText("All mature plants of the same type will be harvested at once, creating a chain combo.")
        level.plant2:show()
        level.plant3:changeTo('Radish', 3)
        level.plant4:changeTo('Radish', 3)
        level.plant5:changeTo('Radish', 3)
        local function harvest(stage)
            if stage == 1 then
                level.hand1:rotate(225)
                level.hand1:BounceTo(4, 4)  
                timer.performWithDelay( 300, function() harvest(2) end, 1 )
            elseif stage == 2 then
                for i=2, 5 do
                    level['plant'..i]:harvest(1, 'x4')
                end
                scoreHUD.text = 17
            end
        end
        nextButton('SaladRot')
        timer.performWithDelay( 300, function() harvest(1) end, 1)
    elseif scene == 'SaladRot' then
        level.textbox1:setText("Clear Withered plants by tapping them.")
        level.textbox1.img.height = 100
        level.textbox2 = textBox(300, 175, 700, 150, 'Clearing a withered plant leaves behind a blighted plot.  No new plants can be planted here for several turns.', 10)
        level.hand1:rotate(315)
        level.hand1:BounceTo(1, 4)
        timer.performWithDelay(400, function() 
            level.plant1:changeTo('Barren', 1)
         end, 1)
        nextButton('SaladStrategy')
    elseif scene == 'SaladStrategy' then
        level.hand1:die()
        level.textbox2:die()
        level.textbox1:setText('Continue setting up combos by planting similar plants next to each other and...')
        for i=1,5 do
            level['plant'..i]:die()
        end
        radish_locs = {{1, 2}, {2, 5}, {1, 4}, {1, 3}, {2, 4}, {3, 5}}
        lettuce_locs = {{3, 2}, {4, 2}, {5, 5}, {5, 4}, {5, 3}, {4, 4}, {4, 3}}
        level.radishes = {}
        level.lettuce = {}
        for i, v in ipairs(radish_locs) do
            level.radishes[v[1]..','..v[2]] = plantObject(v[1], v[2], 'Radish', Plants.mature)
        end
        for i, v in ipairs(lettuce_locs) do
            level.lettuce[v[1]..','..v[2]] = plantObject(v[1], v[2], 'Lettuce', Plants.mature)
        end
        nextButton('SaladPest1')
    elseif scene == 'SaladPest1' then
        level.textbox2 = textBox(300, 400, 700, 150, '...Oh no!  It has begun!  Quickly, destroy the vile pests before all is lost!', 15)
        level.gopher1 = tutorialGopher(2, 2)
        nextButton('SaladPest2')
    elseif scene == 'SaladPest2' then
        level.textbox2:die()
        level.textbox1:setText('If left unchecked, pests can consume growing crops... or worse...')
        level.gopher1:eat(level.radishes['2,4'])
        nextButton('SaladPest3')
    elseif scene == 'SaladPest3' then
        level.textbox1:setText('Destroy earthbound pests with this Mallet of Justice!')
        level.hand1 = tutorialPointer(300, 415)
        theQueue[1].sprite:setSequence('seqMallet')
        level.gopher1:eat(level.lettuce['5,3'])
        nextButton('SaladPest4')
    elseif scene == 'SaladPest4' then
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 200, 'Defeated pests leave stone gravemarkers behind, making the plot unuseable for the remainder of the current level', 15)
        level.hand1:rotate(225)
        level.hand1:BounceTo(level.gopher1.i, level.gopher1.j)
        timer.performWithDelay(450, function()
                level.gopher1:die()
                theQueue:stackedNextEntry()
                level.textbox2 = textBox(300, 450, 700, 150, "*Make sure you don't whack a pest that's sitting on an important junction.  Wait for the right time to strike.", 15)
            end, 1)
        nextButton('SaladBox')
    end

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
    touchesAllowed = false
    step = 1/(depth)
    wait = time/(depth+2)
    print('--@MoveInCurve: wait= '..wait)
    stepNum = 0
    timer.performWithDelay(wait, function() CurveStep(sprite, curve, step, wait) end, depth+1)
    timer.performWithDelay(time, function() touchesAllowed = true end, 1)
end

plantObject = class(function(plant, i, j, type, frame)
    plant.x = theField.grid[i][j].x
    plant.y = theField.grid[i][j].y
    plant.i = i
    plant.j = j
    local sprite = newSprite('seq'..type, plant.x, plant.y)
    sprite:setFrame(frame)

    local decorator = newSprite('seqBlank', plant.x, plant.y)
    if frame == 3 then
        decorator:setSequence('seqTag')
    elseif frame == 4 then
        decorator:setSequence('seqSmell')
        decorator:play()
    else
        decorator.alpha = 0
    end
    layers.field:insert(sprite)
    layers.field:insert(decorator)
    plant.sprite = sprite
    plant.decorator = decorator 
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
    self.sprite:setSequence('seq'..type)
    self.sprite:setFrame(frame)
    if frame == 3 then
        self.decorator:setSequence('seqTag')
        self.decorator.alpha = 1
    elseif frame == 4 then
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
    self.decorator.alpha = 1
end

function plantObject:die()
    self.sprite:removeSelf()
    self.sprite = nil
    self.decorator:removeSelf()
    self.decorator = nil
    self = nil
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
    local txt = display.newText(content, x+padding, y+padding, w-padding, h-padding*2, gameFont, 35)
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
    timer.performWithDelay(250, function() plant:die() end, 1)
end

function tutorialGopher:die()
    local hammer = newSprite('seqMallet', self.x-100, self.y-100)
    hammer:play()
    local function kill()
        self.sprite:setSequence('seqGopherDie')
        self.sprite:play()
        hammer:removeSelf()
        hamme = nil
        timer.performWithDelay(800, function()
                self.sprite:removeSelf()
                rock = newSprite('seqRock', self.x, self.y)
                self.sprite = nil
                self = nil
                layers.field:insert(rock)
                return rock
            end, 1)
    end
    timer.performWithDelay(300, function() kill() end, 1)
end