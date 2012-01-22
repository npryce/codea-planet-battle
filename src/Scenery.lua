do    
    local random = Random()
    
    function drawScenery(planetRadius)
        pushStyle()
        drawPlanet(planetRadius)
        drawStars(planetRadius)
        popStyle()
    end
    
    function drawPlanet(planetRadius)
        pushStyle()
        ellipseMode(RADIUS)
        stroke(255, 255, 255, 255)
        strokeWidth(2)
        fill(0, 0, 0, 255)
        
        ellipse(0, 0, planetRadius)
        
        popStyle()
    end
    
    function drawStars(planetRadius)
        local rng = random:clone()
        
        pushStyle()
        
        rectMode(CORNER)
        noStroke()
    
        for i = 1,125 do
            local x = (rng:uniform() - 0.5) * WIDTH
            local y = (rng:uniform() - 0.5) * HEIGHT
            local b = math.random()*128 + 127
            fill(b,b,b,255)
            rect(math.floor(x), math.floor(y), 2, 2)
        end
        
        popStyle()
    end
end