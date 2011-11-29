Random = class()

function Random:init(seed)
    self.seed = seed or math.random(0, math.huge)
end

function Random:uniform()
    local savedSeed = math.random(0, math.huge)
    
    math.randomseed(self.seed)
    local rnd = math.random()
    self.seed = math.random(0, math.huge)
    math.randomseed(savedSeed)
    
    return rnd
end

function Random:gaussian()
    return (self:uniform() + self:uniform()) * 0.5
end

function Random:spread(distribution, min, max)
    return min + distribution(self)*(max-min)
end

function Random:clone()
    return Random(self.seed)
end
