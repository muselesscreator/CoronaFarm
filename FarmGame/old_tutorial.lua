if scene == 'SaladWelcome' then
        setupScene( {length = 10, nextFunction = 'SaladWelcome1'} )
        textbox1 = textBox(300, 50, 700, 100, 'Welcome to the world of Farmageddon!', 25)
        level.textbox1 = textbox1
        level.textbox2 = textBox(500, 550, 400, 80, '*Click here to continue', 15)
        level.hand1 = tutorialPointer(850, 650)
        level.hand1:rotate(225)
    elseif scene == 'SaladWelcome1' then
        setupScene( { length = 10, nextFunction = 'SaladWelcomeField'})
        level.textbox1:die()
        level.textbox2:die()
        level.hand1:die()
        level.textbox1 = textBox(300, 50, 700, 175, "Our last line of defense against a global pest crisis is your ability to farm epic produce combos.", 25)
    elseif scene == 'SaladWelcomeField' then
        setupScene( { length = 600, nextFunction = 'SaladWelcomeQueue' })
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 250, "This is your field.\nDifferent fields are suitable for growing different types of crops.\nThis field is suitable for growing Radishes and Lettuce.", 25)
        level.hand1 = tutorialPointer(475, 450)
        level.hand1:rotate(140)
        MoveCircle(level.hand1.sprite, 400, 20, 600)
    elseif scene == 'SaladWelcomeQueue' then
        setupScene( { length = 500, nextFunction = 'SaladPlanting1' } )
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 125, "This is your product queue - Currently stacked with plenty of Radish Radish.", 25)
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
    elseif scene == 'SaladPlanting1' then
        setupScene( { length = 500, nextFunction = 'SaladPlanting2' } )
        level.hand2:die()
        level.textbox2:die()
        level.hand1:rotate(225)
        transition.to(level.hand1.sprite, {x=300, y=475, time=200})
        level.textbox1:setText("Tap an empty plot of land to plant the Radish next up in the queue.")
    elseif scene == 'SaladPlanting2' then
        setupScene({ length = 350, nextFunction = 'SaladPlanting3'})        
        level.textbox1:setText("...and the rest of the items in the queue will drop down for use.")
        local curve = bezier:curve({300, 250, 325}, {475, 400, 450})
        MoveInCurve(level.hand1.sprite, curve, 5, 250)
        timer.performWithDelay(150, function()
                level.plant1 = plantObject(1, 4, 'Radish', 1)
                theQueue.weights = {Radish=100}
                theQueue:stackedNextEntry()
                level.hand2 = tutorialPointer(275, 175)
            end, 1)
    elseif scene == 'SaladPlanting3' then
        setupScene( { length = 1200, nextFunction = 'SaladPlanting4' } )
        level.hand2:die()
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 125, "As you continue to plant new Radish, your older plants will grow by a day per turn.", 15)
        level.hand1.x = level.hand1.sprite.x
        level.hand1.y = level.hand1.sprite.y
        level.hand1:BounceTo(2, 4)
        local function planting(stage)
            if stage == 1 then
                theQueue:stackedNextEntry()
                level.plant1:changeTo('Radish', 2)
                level.plant2 = plantObject(2, 4, 'Radish', 1)
                level.hand1:BounceTo(3, 4)
                timer.performWithDelay(400, function() planting(2) end, 1)
            elseif stage == 2 then
                theQueue:stackedNextEntry()
                level.plant1:changeTo('Radish', 3)
                level.plant2:changeTo('Radish', 2)
                level.plant3 = plantObject(3, 4, 'Radish', 1)
                level.hand1:BounceTo(4, 4)
                timer.performWithDelay(400, function() planting(3) end, 1)
            elseif stage == 3 then
                theQueue:stackedNextEntry()
                level.plant1:changeTo('Radish', 4)
                level.plant2:changeTo('Radish', 3)
                level.plant3:changeTo('Radish', 2)
                level.plant4 = plantObject(4, 4, 'Radish', 1)
            end
        end
        timer.performWithDelay(400, function() planting(1) end, 1)
    elseif scene == 'SaladPlanting4' then
        setupScene( { length = 400, nextFunction = 'SaladHarvest1' } )
        level.textbox1:setText("If plants are left unattended for too long, they will wither and rot.")
        level.hand1:BounceTo(5, 4)
        local function planting(stage)
            if stage == 1 then
                theQueue:stackedNextEntry()
                level.plant1:changeTo('Radish', 5)
                level.plant2:changeTo('Radish', 4)
                level.plant3:changeTo('Radish', 3)
                level.plant4:changeTo('Radish', 2)
                level.plant5 = plantObject(5, 4, 'Radish', 1)
            end
        end
        timer.performWithDelay(400, function() planting(1) end, 1)
    elseif scene == 'SaladHarvest1' then
        setupScene( { length = 600, nextFunction = 'SaladHarvest2' } )
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
    elseif scene == 'SaladHarvest2' then
        setupScene( { length = 900, nextFunction = 'SaladRot' } )
        level.textbox1:setText("All mature plants of the same type will be harvested at once, creating a chain combo.")
        level.plant2:show()
        level.plant3:changeTo('Radish', 4)
        level.plant4:changeTo('Radish', 4)
        level.plant5:changeTo('Radish', 4)
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
        timer.performWithDelay( 300, function() harvest(1) end, 1)
    elseif scene == 'SaladRot' then
        setupScene( { length = 400, nextFunction = 'SaladStrategy' } )
        level.textbox1:setText("Clear Withered plants by tapping them.")
        level.textbox1.img.height = 100
        level.textbox2 = textBox(300, 175, 700, 150, 'Clearing a withered plant leaves behind a blighted plot.  No new plants can be planted here for several turns.', 10)
        level.hand1:rotate(315)
        level.hand1:BounceTo(1, 4)
        timer.performWithDelay(400, function() 
            level.plant1:changeTo('Barren', 1)
         end, 1)
    elseif scene == 'SaladStrategy' then
        setupScene( { nextFunction = 'SaladPest1', length = 10})
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
            level.radishes[v[1]..','..v[2]] = plantObject(v[1], v[2], 'Radish', 4)
        end
        for i, v in ipairs(lettuce_locs) do
            level.lettuce[v[1]..','..v[2]] = plantObject(v[1], v[2], 'Lettuce', 4)
        end
    elseif scene == 'SaladPest1' then
        setupScene( { length = 250, nextFunction = 'SaladPest2' } )
        level.textbox2 = textBox(300, 400, 700, 150, '...Oh no!  It has begun!  Quickly, destroy the vile pests before all is lost!', 15)
        level.gopher1 = tutorialGopher(2, 2)
    elseif scene == 'SaladPest2' then
        setupScene( { length = 300, nextFunction = 'SaladPest3' } )
        level.textbox2:die()
        level.textbox1:setText('If left unchecked, pests can consume growing crops... or worse...')
        level.gopher1:eat(level.radishes['2,4'])
    elseif scene == 'SaladPest3' then
        setupScene( { length = 100, nextFunction = 'SaladPest4' } )
        level.textbox1:setText('Destroy earthbound pests with this Mallet of Justice!')
        level.hand1 = tutorialPointer(300, 415)
        theQueue[2].sprite:setSequence('seqMallet')
        theQueue[2].square_type='Mallet'
        theQueue[1].sprite:setSequence('seqMallet')
        level.gopher1:eat(level.lettuce['5,3'])
    elseif scene == 'SaladPest4' then
        setupScene( { length = 700, nextFunction = 'SaladBox' } )
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 200, 'Defeated pests leave stone gravemarkers behind, making the plot unuseable for the remainder of the current level', 15)
        level.hand1:rotate(225)
        level.hand1:BounceTo(level.gopher1.i, level.gopher1.j)
        timer.performWithDelay(450, function()
                level.gopher1:die()
                theQueue:stackedNextEntry()
                level.textbox2 = textBox(300, 450, 700, 150, "*Make sure you don't whack a pest that's sitting on an important junction.  Wait for the right time to strike.", 15)
            end, 1)
    elseif scene == 'SaladBox' then
        setupScene({length = 250, nextFunction = 'SaladBox2'})
        level.textbox2:die()
        level.textbox1:setText('You can store the next item in your queue to be used at a later time by putting it in your crate.')
        level.hand1:rotate(345)
        level.hand1:BounceToXY(300,  600)
    elseif scene == 'SaladBox2' then
        setupScene({length = 400, nextFunction = 'SaladBox3'})
        level.textbox2 = textBox(300, 450, 700, 150, "This is perfect for storing Mallets or Radish for when you need them most.", 15)
        level.hand1:BounceToXY(300, 600)
        timer.performWithDelay(200, function()
                theBasket.decorator:setSequence('seqMallet')
                theBasket.decorator.alpha = 1
                theQueue:stackedNextEntry()
            end, 1)
    elseif scene == 'SaladBox3' then
        setupScene({ length = 250, nextFunction = 'SaladGoForth'})
        level.textbox2:die()
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 115, 'To use the stored item, just tap the storage bin.', 15)
        level.hand1:BounceToXY(275, 600)
        timer.performWithDelay(200, function() theBasket.box:setSequence('seqBoxOpen') end, 1)
    elseif scene == 'SaladGoForth' then
        setupScene({ length = 150, nextFunction='Farm'})
        level.hand1:die()
        level.textbox1:die()
        level.textbox1 = textBox(300, 50, 700, 150, 'Now go forth and farm!  Farm like the world is depending on you... you know... because it is.', 15)
    elseif scene == 'Farm' then
        nextButton()
        storyboard.gotoScene('farm_screen')
    end