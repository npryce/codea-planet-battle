LaserBeam = class()

LaserBeam.speed = 600
LaserBeam.length = 20
LaserBeam.lifespan = 3

function LaserBeam:init(args)
    self.pos = args.pos
    self.dir = args.dir
    self.color = args.color or color(88, 255, 0, 255)
    self.age = 0
end

function LaserBeam:draw()
    pushStyle()
    stroke(self.color)
    strokeWidth(5)
    lineCapMode(SQUARE)
    
    local p1 = self.pos
    local p2 = self.pos - self.dir * self.length
    
    line(p1.x, p1.y, p2.x, p2.y)
    
    popStyle()
end

function LaserBeam:animate(dt)
    self.pos = self.pos + self.dir*self.speed*dt
    self.age = self.age + dt
end

function LaserBeam:isAlive()
    return self.age <= self.lifespan
end