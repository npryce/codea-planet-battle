supportedOrientations(PORTRAIT)

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

function spawnGhostFor(ship)
   launch(ships, Ghost {ship=ship, shipLauncher=launcher(ships)})
end

function setup()
    animator = Group()
    ships = Group()
    projectiles = Group()
    exhaust = Group()
    clouds = Group()
    info = Group()
    
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
    
    displayMode(FULLSCREEN_NO_BUTTONS)
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
    local radiusSq = ship.radius^2
    
    return function(projectile)
        if projectile.pos:distSqr(ship.pos) <= radiusSq then
            ship:damaged()
            if not ship:isAlive() then
	       spawnGhostFor(ship)
            end
        end
    end
end

function resolveCollisions()
    projectiles:each(checkCollisionWith(ship1))
    projectiles:each(checkCollisionWith(ship2))
end

function draw()
    background(0, 0, 0, 255)
    
    animator:animate(DeltaTime)
    resolveCollisions()
    
    smooth()
    pushMatrix()
    
    local halfW = WIDTH/2 
    local halfH = HEIGHT/2
    translate(halfW, halfH)
    
    drawStars(planetRadius)
    trackShips()
    
    drawPlanet(planetRadius)
    
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

instructions = [[
Shoot the other player more times than they shoot you.

On your half of the screen:
 • First finger to touch controls the ship.
 • Second finger to touch fires and controls the gun turret.
]]


function drawInstructions()
    pushMatrix()
    pushStyle()
    
    font("Futura-CondensedMedium")
    fontSize(24)
    textMode(CORNER)
    textWrapWidth(WIDTH)
    
    translate(WIDTH/2, HEIGHT/2)
    
    local function drawInstructionsFor(ship)
        fill(ship.color)
        text(instructions, -WIDTH/2 + 16, -HEIGHT/2 + 16)
    end
    
    drawInstructionsFor(ship1)
    rotate(180)
    drawInstructionsFor(ship2)
    
    popStyle()
    popMatrix()
end

function trackShips()
    local view = ships:bounds():expand(Ship.radius*2)
    local mid = view:center()
    
    scale(math.min(1, WIDTH/view:width(), HEIGHT/view:height()))
    translate(-mid.x, -mid.y)
end
