do    
    local random = Random()
    local screenCenter = vec2(0,0)
    
    function drawScenery(planetRadius)
        local rng = random:clone()
        
        pushStyle()
        drawPlanet(planetRadius)
        drawStars(rng, planetRadius)
        popStyle()
    end
    
    function drawPlanet(planetRadius)
        ellipseMode(RADIUS)
        stroke(255, 255, 255, 255)
        noFill()
        strokeWidth(2)
        
        ellipse(screenCenter.x, screenCenter.y, planetRadius)
    end
    
    function drawStars(rng, planetRadius)
        rectMode(CORNER)
        noStroke()
    
        for i = 1,125 do
            local x = (rng:uniform() - 0.5) * WIDTH
            local y = (rng:uniform() - 0.5) * HEIGHT
            local b = math.random()*128 + 127
            
            if vec2(x,y):distSqr(screenCenter) > planetRadius^2 then
                fill(b,b,b,255)
                rect(math.floor(x), math.floor(y), 2, 2)
            end
        end
    end
end