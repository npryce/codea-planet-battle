Ghost = class()
Ghost.lifespan = 5

function Ghost:init(args)
    local ship = args.ship
    local finishedCallback = finished
    
    self.pos = ship.pos
    self.start = ship.pos
    self.vec = ship.initialPos - ship.pos
    self.age = 0
end

function Ghost:animate(dt)
    self.age = self.age + dt
    self.pos = self.start + self.vec*(self.age/self.lifespan)
end
