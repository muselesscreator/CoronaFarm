
libQueue = class(function(queue, weights, length)
    queue.weights = weights
    queue.length = length
    queue.sequenceData = sequenceData
    queue.myImageSheet = myImageSheet
    return queue
    end)


function libQueue:initialize() --push to fill the queue to the specified number
    for i=1, self.length do
        self[i] = {}
        self[i].contents = self:pickNext()
        theField:updateWeights()
    end
end

function libQueue:nextEntry(weights) --push and pop, return the queue and the element that was popped
    if weights ~= nil then
        theField.weights = weights
    else
        theField:updateWeights()
    end
    l = self.length
    local contents = self:pickNext()
    local sprite = display.newSprite(uiSheet, sequenceData)

    sprite.x = theField.Queue.X
    sprite.y = 0

    sprite:setSequence('ui'..contents.type)
    layers.frame:insert(sprite)

    self[1].sprite.alpha = 0
    self[1].sprite:removeSelf()
 
    for i=1, self.length-1 do

        self[i].sprite = self[i+1].sprite
        self[i].contents = self[i+1].contents

    end


    self[l].sprite = sprite
    self[l].contents = contents

    for i=1, self.length do

        new_y = theField.Queue.Y - (125*(i-1))
        print(i..' to '..new_y)

        if i==1 then
            transition.to(self[i].sprite, {time=300, y=new_y, transition=easing.outBounce})
        else
            transition.to(self[i].sprite, {time=400, y=new_y, transition=easing.outBounce})
        end

    end
end

function libQueue:pickNext()  --pick the next element in the queue based on weighted inputs
    local used = 1
    local total_weight=0

    w_str = ''
    for i, v in pairs(self.weights) do
        w_str = w_str.. ' '..i..': '..v..'      '
    end
    print(w_str)

    for n in pairs(self.weights) do
        total_weight = total_weight + self.weights[n]
    end

    local rand = math.random(1,total_weight)

    for n in pairs(self.weights) do

        if rand < used + self.weights[n] then
            if n == 'Mallet' or n == 'Slingshot' then
                return {type = n, is_weapon = true}
            else
                return {type = n, is_weapon = false}
            end
        else
            used = used + self.weights[n]
        end

    end

    print("No match found in queue selection: "..rand)
end

function libQueue:fill()
    self:initialize()
    local i = 0
    for key, val in ipairs(self) do
        i = i+1
        local sprite = display.newSprite(uiSheet, sequenceData)
        sprite:setSequence('ui'..val.contents.type)
        sprite.x = theField.Queue.X
        sprite.y = theField.Queue.Y - (i-1)*125
        val.sprite = sprite
        layers.frame:insert(sprite)
    end
end
