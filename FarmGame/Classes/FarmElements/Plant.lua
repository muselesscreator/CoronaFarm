local Super = FarmElement
Plant = Class(Super)

function Plant:initialize(args)
    Super.initialize(self, args)
    self.type = args.type

    self.turns = Plants[self.type].turns
    self.xp = Plants[self.type].xp
    local tmp = Plants[self.type].maxHarvest
    if #tmp then
        self.maxHarvest = tmp[math.random(1, #tmp)]
    else
        self.maxHarvest = tmp[1]
    end

    self.draw_priority = 1

    self.base_sprite:setSequence('seq'..self.type)
    self.base_sprite:setFrame(1)

    self.myStage = 1
    self.myProgress = 0
    self.timesHarvested = 0
    self.harvesting = 0

    self.harvest_bunch = {}

    self.mature = 4
    self.rot = 5

    self.checked = false

    self.elem_type = 'Plant'

    theField:addElement(self)
    self:addSpritesToLayers()
end

function Plant:grow()
    print('--@Plant:grow')
    self.myStage = self.myStage + 1
    self.base_sprite:setSequence(self.myType)
    self.base_sprite:setFrame(self.myStage)
    self.myProgress = 0
    if self.myStage == self.mature then
        self.overlay:setSequence('seqTag')
        self.overlay.alpha = 1
    elseif self.myStage == self.rot then
        self.overlay:setSequence('seqSmell')
        self.overlay.alpha = 1
        self.overlay:play()
    end 
end

function Plant:nextDay()
    self.myProgress = self.myProgress + 1
    if self.myProgress > self.turns[self.myStage] then
        self:grow()
    elseif self.myStage == self.mature and self.myProgress > self.turns[self.myStage]-3 then
        self.base_sprite:setSequence('seq'..self.type..'Frame'..(3+self.myProgress-self.turns[self.myStage]))
        self.base_sprite:play()
    end
end

function Plant:nextIsValid()
    return self.whatIsNext().is_weapon
end

function Plant:canClick()
    if self:nextIsValid() or self.myStage == self.mature or self.myStage == self.rot then
        return true
    end
end

function Plant:onClick()
    if self:canClick() then
        if self.myStage == self.mature then
            local bunch = self:checkNeighbors({})
            mult = #bunch
            for i, v in ipairs(bunch) do
                v:harvest(mult)
                thePlayer:addScore(v.xp * mult)
            end
            timer.performWithDelay(550, function() theField:nextDay() end, 1)
        elseif self:nextIsValid() then
            local pest = theField:pestAt(self.i, self.j)
            if pest ~= false then
                pest:onClick(event)
            else
                self:useWeapon()
            end
            self:useNext()
        else -- At this point, we can assume it is rotten
            self:prune()
            theField:nextDay()
        end
    end
end

function Plant:useWeapon()
    if self:whatIsNext().type == 'Mallet' then
        FarmElement.useWeapon(self)
        timer.performWithDelay(250, function()
            local tmp = Blank:new({i=self.i, j=self.j})
            self:die()
            theField:nextDay()
            end, 1)
    else
        FarmElement.useWeapon(self)
        timer.performWithDelay(250, function() theField:nextDay() end, 1)
    end
end

function Plant:harvest(multiplier)
    if multiplier == 1 then 
        multiplier = false
    else
        multiplier = ('x'..multiplier)
    end
    local mult = {}
    x = self.x
    y = self.y
    local score = display.newText(self.xp, x+160, y+58, 250, 250, gameFont, 35)
    score.alpha = 1
    layers.overlays:insert(score)
    if multiplier then
        mult = display.newText(multiplier, x+225, y-75, 250, 250, gameFont, 35)
        mult:setFillColor(.3, .3, .8)
        mult.alpha = 1
        mult.size=45
        mult:rotate(-45)
        layers.overlays:insert(mult)
    end
    self.overlay:setSequence('seqBlank')
    self.overlay.alpha = 0
    self.base_sprite:setSequence('seq'..self.type..'Harvest')
    self.base_sprite:play()
    self.timesHarvested = self.timesHarvested + 1
    timer.performWithDelay(200, function()
        if theField:pestAt(self.i, self.j) ~= false then
            self.overlay:setSequence('seqBlank')
            self.overlay.alpha = 0
        elseif self.timesHarvested >= self.maxHarvest then
            self:toBlank()
        else
            self.base_sprite:setFrame(self.mature-1)
            self:clearDecorator()
        end
        timer.performWithDelay(350, function()
                score:removeSelf()
                score = nil
                if multiplier then
                    mult:removeSelf()
                    mult = nil
                end
            end)
        end)
end

function Plant:clearDecorator()
    self.decorator:setSequence('seqBlank')
    self.decorator.alpha = 0
end

function Plant:checkNeighbors(bunch)
    print('--@Plant:checkNeighbors')
    bunch[#bunch+1] = self
    self.checked = true
    n = self:getNeighbors()
    for i, v in pairs(n) do
        for j, val in ipairs(v) do
            if val.elem_type == 'Plant' then
                print('plant neighbor')
                if val.myStage == val.mature and not val.checked and val.type == self.type then
                    bunch = val:checkNeighbors(bunch)
                end
            end
        end
    end
    return bunch
end


function Blank:removeFromField()
    for i, v in ipairs(theField.elements.Plant) do
        if v == self then
            table.remove(theField.elements.Plant, i)
        end
    end
end

function Plant:prune()
    local tmp = Barren(self.i, self.j, {turns_remaining = self.turns[5]})
    self:die()
end

function Plant:toBlank()
    print('toBlank')
    local tmp = Blank:new({i=self.i, j=self.j})
    self:die() 
end

function Plant:cleanup()
    self.checked = false
end