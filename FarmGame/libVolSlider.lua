--Volume Slider
require 'class'


function volSlide(self, event)
    if event.phase == 'moved' and event.id == self.target.move_id then
        if event.x <= self.target.maxX and event.x >= self.target.minX then
            self.target.icon.x = event.x
        elseif event.x > self.target.maxX then
            self.target.icon.x = self.target.maxX
        else
            self.target.icon.x = self.target.minX
        end
        self.target.icon:dispatchEvent({name = self.target.event, value = self.target:value()})
        return true
    elseif  event.phase == 'began' then
        print('began')
        if event.x < self.target.maxX + 10 and 
            event.x > self.target.minX - 10 and
            event.y < self.target.icon.y + 37 and
            event.y  > self.target.icon.y - 37 then
            print('actually began')

            if event.x <= self.target.maxX and event.x >= self.target.minX then
                self.target.icon.x = event.x
            elseif event.x > self.target.maxX then
                self.target.icon.x = self.target.maxX
            else
                self.target.icon.x = self.target.minX
            end
            self.target.icon:dispatchEvent({name = self.target.event, value = self.target:value()})
            self.target.move_id = event.id
            return true
        end
    end
end

VolSlider = class(function(slider, args)
    slider.event = args.event

    slider.track = display.newImage('images/track.png')
    slider.track.anchorX = 0
    slider.track.x = args.x
    slider.track.y = args.y + args.h/2-5

    slider.icon = display.newImage('images/buttonSoundDrag.png')
    local myX = (args.startX * args.w) + args.x
    slider.icon.x = myX
    slider.icon.y = args.y + args.h/2
    slider.track.width = args.w

    slider.w = args.w
    slider.minX = args.x
    slider.maxX = args.x + args.w
    slider.move_id = 0
    slider.range = args.range

    touch_obj = display.newRect(0, 0, w, h)
    touch_obj.anchorX = 0
    touch_obj.anchorY = 0
    touch_obj.alpha = 0
    touch_obj.isHitTestable = true
    touch_obj.target = slider
    touch_obj.touch = volSlide
    touch_obj:addEventListener( "touch", touch_obj )
    slider.touch_obj = touch_obj
    layers.popup:insert(slider.track)
    layers.popup:insert(slider.icon)
    layers.popup:insert(touch_obj)
    return slider
    end
    )

function VolSlider:value()
    return math.floor((self.icon.x - self.minX)/self.w*self.range)
end