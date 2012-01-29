Ghost = class()
Ghost.lifespan = 5

function Ghost:init(args)
    self.ship = args.ship
    self.launcher = args.shipLauncher
    self.pos = self.ship.pos
    self.start = self.ship.pos
    self.vec = self.ship.initialPos - self.ship.pos
    self.age = 0
end

function Ghost:bounds()
   return Bounds.fromPoint(self.pos)
end

function Ghost:animate(dt)
    self.age = math.min(self.age + dt, self.lifespan)
    self.pos = self.start + self.vec*((self.age/self.lifespan)^2)
    
    if not self:isAlive() then
        self.ship:reset()
        self.launcher(self.ship)
    end
end

function Ghost:isAlive()
    return self.age < self.lifespan
end

function Ghost:draw()
    -- nothing
end
