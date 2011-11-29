Repeater = class()

function Repeater:init(args)
    self.period = args.period
    self.action = args.action
    
    if args.active ~= nil then
        self.active = args.active
    else
        self.active = true
    end
    
    self.counter = 0
end

function Repeater:animate(dt)
    self.counter = self.counter - dt
    while self.counter < 0 do
        if self.active then
            self.action()
            self.counter = self.counter + self.period
        else
            self.counter = 0
        end
    end
end

function Repeater:start()
    self.active = true
end

function Repeater:stop()
    self.active = false
end