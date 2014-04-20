require 'class'
require 'plants'
require 'fieldEvents'
require 'libField'

FarmElement = class(function(elem, x, y, i, j)
            for num, v in pairs(theField.blocked) do
                if i == v[1] and j == v[2] then
                    elem.blocked = true
                end
            end

            local sprite = display.newSprite(myImageSheet, sequenceData)
            sprite:setSequence("seqBlank")
            sprite.alpha = .01
            sprite.empty = true
            sprite.x = x
            sprite.y = y

            local decorator = display.newSprite(myImageSheet,
                sequenceData)
            decorator:setSequence("seqBlank")
            decorator.alpha = .01
            decorator.x = x
            decorator.y = y

            local birdLayer = display.newSprite(myImageSheet, sequenceData)
            birdLayer:setSequence("seqBird")
            birdLayer.alpha = 0
            birdLayer.x = x
            birdLayer.y = y - 275

            local weaponLayer = display.newSprite(myImageSheet,
                sequenceData)
            weaponLayer:setSequence("seqBlank")
            weaponLayer.alpha = .01
            weaponLayer.x = x-50
            weaponLayer.y = y-100

            sprite.row = j
            sprite.column = i
            sprite.id = i..','..j
            elem.id = i..','..j
            sprite.myStage = 1
            sprite.myProgress = 0
            sprite.myType = 'blank'
            sprite.timesHarvested = 0
            sprite.checked = false
            sprite.pestProof=false
            sprite.isPlant = false
            sprite.isBarren = false
            sprite.neighbors = {above = false,
                             below = false,
                             right = false,
                             left = false}
            sprite.pest = false
            function sprite:square()
                return theField.grid[sprite.column][sprite.row]
            end
            sprite.next = false
            sprite.tap = onSquareTap
            sprite:addEventListener("tap", sprite)

            layers.field:insert(sprite)
            layers.overlays:insert(decorator)
            layers.birdLayer:insert(birdLayer)
            layers.weaponLayer:insert(weaponLayer)
            elem.sprite = sprite
            elem.decorator = decorator
            elem.birdLayer = birdLayer
            elem.weaponLayer = weaponLayer
            return elem
            end)

function FarmElement:setNeighbors()
    sprite = self.sprite
    x = sprite.column
    y = sprite.row
    if x > 1 then
        tmp = theField.grid[x-1][y]
        if not tmp.blocked then
            sprite.neighbors.left = tmp.sprite
        end
    end
    if y > 1 then
        tmp = theField.grid[x][y-1]
        if not tmp.blocked then
            sprite.neighbors.above = tmp.sprite
        end
    end
    if x < theField.columns then
        tmp = theField.grid[x+1][y]
        if not tmp.blocked then
            sprite.neighbors.right = tmp.sprite
        end
    end
    if y < theField.rows then
        tmp = theField.grid[x][y+1]
        if not tmp.blocked then
            sprite.neighbors.below = tmp.sprite
        end
    end
end

function FarmElement:initialize()
    --print("--@FarmElement:initialize(): "..self.id)
    self:setSpriteFunctions()
    local sprite = self.sprite
    self:setNeighbors()
    if sprite.column < theField.columns then
        self.next = theField.grid[sprite.column + 1][sprite.row]
    elseif sprite.row < theField.rows then
        self.next = theField.grid[1][sprite.row + 1]
    end
end

function FarmElement:setSpriteFunctions()
    local sprite = self.sprite
    function sprite:checkNeighbors()
        print('--@FarmElement.sprite:checkNeighbors')
        local plant = sprite.plant
        local parent = sprite:square()
        local myType = sprite.myType
        --print("--@checkNeighbors: checking: "..sprite.id)
        if sprite.checked == true or sprite.myStage ~= Plants.mature  then
            --print("--@checkNeighbors: not this one")
            return true
        end
        sprite.timesHarvested = sprite.timesHarvested + 1
        sprite.checked = true
        AddPlantsHarvested(self)
        for i, tmp in pairs(sprite.neighbors) do
            if tmp then
                if tmp.checked == false and tmp.myType==myType then
                    tmp:checkNeighbors()
                end
            end
        end
    end
    function sprite:grow()
        print('--@FarmElement.sprite:grow')
        self.myStage = self.myStage + 1
        --print("--@nextDay: now at stage "..self.myStage)
        square:setImage(self.myType, self.myStage)
    end
end

function FarmElement:harvest(score, multiplier)
    if multiplier == 1 then 
        multiplier = false
    else
        multiplier = ('x'..multiplier)
    end
    local mult = {}
    x = self.sprite.x
    y = self.sprite.y
    points = self.sprite.plant.xp
    local star = newSprite('seqScoreStar', x, y)
    star.width = 25
    star.heigh = 25
    layers.overlays:insert(star)
    transition.to(star, {y=y - 100, width = 85, height = 85, alpha=.8, time=100})
    local score = display.newText(points, x+115, y+5, 250, 250, CustomFont, 35)
    score.alpha = 1
    layers.overlays:insert(score)
    if multiplier then
        mult = display.newText(multiplier, x+175, y-150, 250, 250, CustomFont, 35)
        mult:setFillColor(.3, .3, .8)
        mult.alpha = 0
        mult.size=45
        mult:rotate(-45)
        layers.overlays:insert(mult)
    end
    local function burst(stage)
        if stage == 1 then
            transition.to(star, {width = 150, height=150, alpha = 0, time=300})
            score.alpha = 1
            score:setFillColor(.3, .3, .8)
            transition.to(score, {width=300, height=300, size=35, alpha=0, time=200})
            if multiplier then
                mult.alpha = 1
                transition.to(mult, {width=300, height=300, size=45, alpha=0, time=300})
            end
            if self.sprite.timesHarvested >= self.sprite.maxHarvest then
                self:clearImage()
            else
                self:setImage(self.sprite.myType, self.sprite.myStage-1, false)
                self:clearDecorator()
            end
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
    timer.performWithDelay( 250, function() burst(1) end, 1 )
end

function FarmElement:setSequence(seq)
    self.sprite:setSequence(seq)
end

function FarmElement:setFrame(frame)
    self.sprite:setFrame(frame)
end

function FarmElement:setImage(myType, phase, pest)
    print('--@FarmElement:setImage')
    local phase = phase or 0
    local pest = pest or false
    --print('--@FarmElement:setImage: set '..self.id..' to myType '..myType..' phase '..phase)
    sprite = self.sprite
    if myType == 'Rock' then
        self.isPlant = false
        self.myType = 'Rock'
        self.pestProof=true
        self.sprite.isBarren = false
        self.sprite.pest = false
        self:clearDecorator()
        self:setSequence('seqRock')
    elseif pest == false then
        print(myType)
        sprite.isPlant = true
        sprite.plant = Plants[myType]
        sprite.toNext = sprite.plant.turns[phase]
        sprite.xp = sprite.plant.xp
        if phase == 1 then
            --print('--@FarmElement:setImage: placing seeds')
            self:setSequence('seq'..myType)
            r = math.random(1, #Plants[myType].maxHarvest)
            self.sprite.maxHarvest = Plants[myType].maxHarvest[r]
        else
            self:setSequence('seq'..myType)
            self:setFrame(phase)
            if self.sprite.myStage == Plants.rot then
                self:setDecorator('smell')
            elseif self.sprite.myStage == Plants.mature then
                self:setDecorator('tag')
            else
                self:clearDecorator()
            end
        end
    else
        if myType=='seqGopher' then
            self:setSequence('seqGopher')
            self.sprite:play()
            sprite.pestProof=true
            self:clearDecorator()
            sprite.isPlant = false
        end
    end
    sprite.myStage = phase
    if sprite.myStage==Plants.rot then
        sprite.pestProof=true
    end
    sprite.myType = myType
    sprite.empty = false
    sprite.alpha = 1
    sprite.myProgress = 0
    sprite.checked = false

end

function FarmElement:clearImage()
    print('--@FarmElement:clearImage: clearing sprite.id='..self.sprite.id)
    self:setSequence('seqBlank')
    self.sprite.empty = true
    self.sprite.alpha = .01
    self.sprite.timesHarvested = 0
    self.sprite.myStage = 0
    self.sprite.myProgress = 0
    self.sprite.myType = "blank"
    self.sprite.pestProof = false
    self.sprite.isPlant = false
    self.sprite.checked = false
    self.sprite.isBarren = false
    self.sprite.pest = false
    self:clearDecorator()
end

function FarmElement:makeBarren()
    print("--@FarmElement:makeBarren")
    self:setSequence('seqBarren')
    self:setFrame(1)
    self.sprite.alpha = 1
    self:clearDecorator()
    self.sprite.isBarren = true
    self.sprite.myStage = 6
    self.sprite.empty = false
    self.sprite.myProgress = 0
end

function FarmElement:setDecorator(dec)
    print('--@FarmElement:setDecorator')
    if dec == 'smell' then
        self.decorator:setSequence('seqSmell')
        self.decorator.alpha = 1
        self.decorator:play()
    elseif dec == 'seqBird' then
        self.decorator:setSequence('seqBird')
        self.decorator.alpha = 1
        self.decorator:play()
    elseif dec == 'seqSwoop' then
        self.decorator:setSequence('seqSwoop')
        self.decorator.alpha = 1
        self.decorator:play()
    elseif dec == 'tag' then
        --print('--@FarmElement:setDecorator:  set Tag')
        self.decorator:setSequence('seqTag')
        self.decorator.alpha = 1
    end
end

function FarmElement:clearDecorator()
    print('--@FarmElement:clearDecorator')
   -- print('--@FarmElement:clearDecorator: clearing decorator sprite.id='..self.sprite.id)
    self.decorator:setSequence('seqBlank')
    self.decorator.alpha = .01
end

function FarmElement:addPest(pest)
    print('--@FarmElement:addPest pest at '..self.id)
    self.sprite.pest = pest
    if pest.myType == 'air' then
        self.birdLayer:setSequence('seqBird')
        self.birdLayer.alpha = 1
        self.birdLayer:play()
    else
        --print(pest.image)
        self:setImage(pest.image, 0, true)
    end
    return 0
end

function FarmElement:birdSwoop()
    self.birdLayer:setSequence('seqSwoop')
    self.birdLayer.alpha = 1
    self.birdLayer:play()
end
