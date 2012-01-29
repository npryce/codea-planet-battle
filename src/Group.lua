-- Collections of game objects
    
do
    Group = class()
    Group.mortal = false
    
    function Group:init()
        self.things = {}
    end
    
    function Group:add(thing)
        table.insert(self.things, thing)
    end
    
    function Group:each(func)
        local function isAlive(a)
            return a.isAlive == nil or a:isAlive()
        end
        
        local lastFrame = self.things
        self.things = {}
        
        for i, thing in pairs(lastFrame) do
            if isAlive(thing) then
                func(thing)
                if isAlive(thing) then
                    self:add(thing)
                end
            end
        end
    end
    
    function Group:animate(dt)
        while dt > 0.1 do
            self:each(function (a) a:animate(0.1) end)
            dt = dt - 0.1
        end
        self:each(function (a) a:animate(dt) end)
    end
    
    function Group:draw()
        self:each(function (d) d:draw() end)
    end
    
    function Group:bounds()
        local function mergeBounds(bounds, thing)
            return Bounds.merge(
                bounds, 
                thing.bounds ~= nil and thing:bounds())
        end
       
        return fold(self.things, nil, mergeBounds)
    end
    
    function Group:isAlive()
        return self.mortal and #self.things > 0
    end
end
