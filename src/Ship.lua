Ship = class()

Ship.minSpeed = 100
Ship.maxSpeed = 400
Ship.maxTurnRate = 180
Ship.random = Random()
Ship.radius = 15

function Ship:init(args)
    self.color = args.color
    self.initialPos = args.pos
    self.initialBearing = args.bearing
    self.spawnExhaust = args.spawnExhaust
    self.spawnProjectile = args.spawnProjectile
    self.exhaust = Repeater {
        period = 0.005,
        action = function() self:emitExhaust() end,
        active = false
    }
    self.gun = Repeater {
        period = 1/3,
        action = function() self:fire() end,
        active = false
    }
    
    self.deathCount = 0
    self:reset()
end

function Ship:reset()
    self.pos = self.initialPos
    self.bearing = self.initialBearing
    self.desiredBearing = self.initialBearing
    self.turretBearing = self.initialBearing
    self.speed = 0
    self.turnRate = 0
    self.isAiming = false
    self.alive = true
end

function Ship:bounds()
   return Bounds.fromCenter(self.pos, self.radius)
end

function Ship:animate(dt)
    local maxDeltaBearing = self.turnRate*dt
    local desiredDeltaBearing = wrap(
        self.desiredBearing - self.bearing, -180, 180)
    local deltaBearing = clampMagnitude(
        desiredDeltaBearing, maxDeltaBearing)
    
    self.bearing = self.bearing + deltaBearing
    
    if not self.isAiming then
        self.turretBearing = self.turretBearing + deltaBearing
    end
    
    local vel = bearingToVector(self.bearing) * self.speed
    local newPos = self.pos + vel*dt
    local xWrap = WIDTH/2 + self.radius*2
    local yWrap = HEIGHT/2 + self.radius*2
    
    self.pos = newPos
    
    self.exhaust:animate(dt)
    self.gun:animate(dt)
end

function Ship:isLaunched()
    return self.speed > 0
end

function Ship:startEngine()
    self.exhaust:start()
end

function Ship:steer(v)
    local len = v:len() -- v is already normalized
    self.speed = blend(self.minSpeed, self.maxSpeed, len)
    if v ~= vec2(0,0) then
        self.desiredBearing = bearingOf(v)
        self.turnRate = (2-len)/2 * self.maxTurnRate
    end
end

function Ship:startFiring()
    self.gun:start()
end

function Ship:aim(v)
    self.isAiming = (v ~= vec2(0,0))
    if self.isAiming then
        self.turretBearing = bearingOf(v)
    end
end
 
function Ship:fire()
    local dir = bearingToVector(self.turretBearing)
    self.spawnProjectile(LaserBeam {
        pos = self.pos + dir*20,
        dir = dir
    })
end

function Ship:stopFiring()
    self.isAiming = false
    self.gun:stop()
end

function Ship:emitExhaust()
    if self.speed > 0 then
        local direction = -bearingToVector(self.bearing):rotate(
            (self.random:uniform()-0.5)*math.pi/8)
        
        self.spawnExhaust(Spark {
            pos = self.pos + direction * 20,
            vel = direction * self.random:uniform() * self.speed/2,
            lifespan = 0.5
        })
    end
end

function Ship:isAlive()
    return self.alive
end

function Ship:damaged()
    self.deathCount = self.deathCount + 1
    self.alive = false
    self:explode()
end

function Ship:explode()
    for i = 1,200 do
        local speed = self.random:gaussian()*80
        local dir = vec2(1,0):rotate(self.random:uniform()*math.pi*2)
        local initialColor
        local finalColor
        
        if self.random:uniform() < 0.5 then
            initialColor = self.color
            finalColor = color(0, 0, 0, 0)
        else
            initialColor = color(242, 221, 41, 255)
            finalColor = color(128, 38, 29, 0)
        end
        
        self.spawnExhaust(Spark {
            pos = self.pos + dir*(self.random:gaussian()*self.radius*2),
            vel = dir*speed,
            lifespan = 5,
            initialColor = initialColor,
            finalColor = finalColor
        })
    end
end

function bearingOf(v)
    return math.deg(math.atan2(v.x, v.y))
end

function bearingToVector(degrees)
    local radians = math.rad(degrees)
    return vec2(math.sin(radians), math.cos(radians)) -- bearings are relative to "up"
end

function Ship:draw()
    pushStyle()
    
    pushMatrix()
    translate(self.pos.x, self.pos.y)
    scale(0.125)
    
    pushMatrix()
    
    rotate(-self.bearing)
    
    ellipseMode(CORNERS)
    rectMode(CORNERS)
    
    --fuselage
    noStroke()
    fill(self.color)
    ellipse(-75, -150, 75, 100)
    fill(0, 0, 0, 255)
    rect(-50, -125, 50, -150)
    
    --legs
    strokeWidth(25)
    stroke(self.color)
    line(-50, -50, -125, -150)
    line(50, -50, 125, -150)
    
    popMatrix()
    
    pushMatrix()
    
    --turret
    rotate(-self.turretBearing)
    
    fill(0, 0, 0, 255)
    stroke(0, 0, 0, 255)
    
    ellipseMode(RADIUS)
    ellipse(0, 0, 30, 30)
    rect(-10, 25, 10, 60)

    popMatrix()

    popMatrix()
    
    popStyle()
end