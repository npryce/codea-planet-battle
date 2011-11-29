

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
    animator = Animator()
    ships = Layer()
    projectiles = Layer()
    exhaust = Layer()
    clouds = Layer()
    
    ship1 = Ship {
        color=player1Color, 
        pos=vec2(WIDTH/2, HEIGHT/2 + planetRadius), 
        bearing=0,
        spawnExhaust=launcher(exhaust),
        spawnProjectile=launcher(projectiles)
    }
    ship2 = Ship {
        color=player2Color, 
        pos=vec2(WIDTH/2, HEIGHT/2 - planetRadius),
        bearing=180,
        spawnExhaust=launcher(exhaust),
        spawnProjectile=launcher(projectiles)
    }
    
    launch(ships, ship1)
    launch(ships, ship2)
    
    for i = 1,12 do
        launch(clouds, Cloud(vec2(WIDTH/2, HEIGHT/2), 
                             planetRadius + 40 + math.random()*20))
    end
    
    controller = SplitScreen {
        top = controllerFor(ship2),
        bottom = controllerFor(ship1)
    }

    controller:activate()
    
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
    drawScenery(planetRadius)
    animator:animate(DeltaTime)
    
    resolveCollisions()
    
    ships:draw()
    projectiles:draw()
    exhaust:draw()
    clouds:draw()
    controller:draw()
end


