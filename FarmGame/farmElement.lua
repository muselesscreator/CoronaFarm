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
            weaponLayer.x = x
            weaponLayer.y = y

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
        AddPlantsHarvested(1)
        --addScore(sprite.xp)
        --print("--@checkNeighbors: new timesHarvested: "..sprite.timesHarvested..' vs maxHarvest '..plant['maxHarvest'])
        if sprite.timesHarvested >= sprite.maxHarvest then
            parent:clearImage()
        else
            print('--@farmElement.sprite:checkNeighbors  reverting stage')
            parent:setImage(myType, self.myStage-1, false)
            parent:clearDecorator()
        end

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
        self:clearDecorator()
        self:setSequence('seqRock')
    elseif pest == false then
        print(myType)
        sprite.isPlant = true
        sprite.plant = Plants[myType]
        sprite.toNext = sprite.plant.turns[phase + 1]
        sprite.xp = sprite.plant.xp
        if phase == 0 then
            --print('--@FarmElement:setImage: placing seeds')
            self:setSequence('seqSeeds')
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
    self.sprite.myStage = 5
    self.sprite.empty = false
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
    print('--@FarmElement:addPest pest at '..self.id..'=')
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
