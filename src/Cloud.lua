Cloud = class()

Cloud.color = color(202, 202, 202, 255)

function Cloud:init(center, altitude)
    self.center = center
    self.rng = Random()
    self.altitude = altitude
    self.angle = self.rng:uniform() * 360
    self.drift = (self.rng:uniform() - 0.5)*5
end

function Cloud:draw()
    local rng = self.rng:clone()
    pushStyle()
    pushMatrix()
    
    translate(self.center.x, self.center.y)
    rotate(self.angle)
    translate(0, self.altitude)
    
    ellipseMode(RADIUS)
    fill(self.color)
    stroke(self.color)
    
    local numCircles = 4 + rng:uniform(4)
    local spacing = 16
    
    for i = 1,numCircles do
        local x = i * spacing - ((numCircles/2)*spacing)
        local y = rng:gaussian() * spacing
        local radius = spacing + rng:gaussian() * spacing
        
        ellipse(x, y, radius)
    end
    
    popMatrix()
    popStyle()
end

function Cloud:animate(dt)
    self.angle = wrap(self.angle + self.drift*dt, 0, 360)
end
