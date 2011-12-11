

player1Color = color(255,0,0,255)
player2Color = color(0, 164, 255, 255)
planetRadius = 120

function launch(layer, sprite)
    animator:add(sprite)
    layer:add(sprite)
end

function launcher(layer)
    return function(sprite)
        launch(layer, sprite)
    end
end

function setup()
    font = ZXMonospace()
    fontStyle = SimpleFontStyle {size=2}
    
    animator = Animator()
    ships = Layer()
    projectiles = Layer()
    exhaust = Layer()
    clouds = Layer()
    
    ship1 = Ship {
        color=player1Color, 
        pos=vec2(0, planetRadius), 
        bearing=0,
        spawnExhaust=launcher(exhaust),
        spawnProjectile=launcher(projectiles)
    }
    ship2 = Ship {
        color=player2Color, 
        pos=vec2(0, -planetRadius),
        bearing=180,
        spawnExhaust=launcher(exhaust),
        spawnProjectile=launcher(projectiles)
    }
    
    launch(ships, ship1)
    launch(ships, ship2)
    
    for i = 1,12 do
        launch(clouds, Cloud(vec2(0,0), 
                             planetRadius + 40 + math.random()*20))
    end
    
    controller = SplitScreen {
        top = controllerFor(ship2),
        bottom = controllerFor(ship1)
    }

    controller:activate()
    
    displayMode(FULLSCREEN)
    
    print("Controls:")
    print("")
    print("First finger  - steer")
    print("Second finger - fire")
    print("")
    print("Player 1 - bottom half of screen")
    print("Player 2 - top half of screen")
    print("")
    print("")
    print("Scramble!")
end

function controllerFor(ship)
    return Prioritized(
        VirtualStick {
            pressed = function() ship:startEngine() end,
            moved = function(v) ship:steer(v) end
        },
        VirtualStick {
            pressed = function() ship:startFiring() end,
            moved = function(v) ship:aim(v) end,
            released = function(v) ship:stopFiring() end
        }
    )
end

function checkCollisionWith(ship)
    return function(projectile)
        if projectile.pos:distSqr(ship.pos) <= ship.radius^2 then
            ship:damaged()
        end
    end
end

function resolveCollisions()
    projectiles:each(checkCollisionWith(ship1))
    projectiles:each(checkCollisionWith(ship2))
end

function draw()
    background(0, 0, 0, 255)
    smooth()
    
    pushMatrix()
    
    local halfW = WIDTH/2 
    local halfH = HEIGHT/2
    
    translate(halfW, halfH)
    
    trackShips()
    
    drawScenery(planetRadius)
    animator:animate(DeltaTime)
    
    resolveCollisions()
    
    ships:draw()
    projectiles:draw()
    exhaust:draw()
    clouds:draw()
    popMatrix()
    
    if not (ship1:isLaunched() or ship2:isLaunched()) then
        drawInstructions()
    end
    
    controller:draw()
end

function drawInstructions()
    pushMatrix()
    pushStyle()
        
    noSmooth()
    stroke(255, 255, 255, 255)
    line(0, HEIGHT/2, WIDTH, HEIGHT/2)
    
    translate(WIDTH/2, HEIGHT/2)
    
    pushMatrix()
    translate(-WIDTH/2, -24)
    
    fill(ship1.color)
    font:render("Player 1 Controls This Side", fontStyle)
    popMatrix()
    
    rotate(180)
    translate(-WIDTH/2, -24)
    fill(ship2.color)
    font:render("Player 2 Controls This Side", fontStyle)
    
    popStyle()
    popMatrix()
end

function trackShips()
    local p1 = ship1.pos
    local p2 = ship2.pos
    local d = Ship.radius*4
        
    local sepX = math.abs(p1.x - p2.x) + d
    local sepY = math.abs(p1.y - p2.y) + d
    local mid = avg(p1, p2)
        
    scale(math.min(1, WIDTH/sepX, HEIGHT/sepY))
    translate(-mid.x, -mid.y)
end 
