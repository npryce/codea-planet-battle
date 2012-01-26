-- Axis-aligned bounding box

Bounds = class()

function Bounds:init(minx, miny, maxx, maxy)
   self.minx = minx
   self.miny = miny
   self.maxx = maxx
   self.maxy = maxy
end

function Bounds.fromCorners(c1, c2)
   return Bounds(math.min(c1.x, c2.x),
		 math.min(c1.y, c2.y),
		 math.max(c1.x, c2.x),
		 math.max(c1.y, c2,y))
end

function Bounds.fromCenter(c, width, height)
   local halfw = width/2
   local halfh = (height or width)/2
   
   return Bounds(c.x - halfw,
		 c.y - halfh,
		 c.x + halfw,
		 c.y + halfh)
end

function Bounds.fromPoint(p)
   return Bounds(p.x, p.y, p.x, p.y)
end

function Bounds:width()
   return self.maxx - self.minx
end

function Bounds:height()
   return self.maxy - self.miny
end

function Bounds:center()
    return vec2(avg(self.minx, self.maxx), avg(self.miny, self.maxy))
end

function Bounds.merge(b1, b2)
   if b1 == nil then
      return b2
   elseif b2 == nil then
      return b1
   else
      return Bounds(math.min(b1.minx, b2.minx),
		    math.min(b1.miny, b2.miny),
		    math.max(b1.maxx, b2.maxx),
		    math.max(b1.maxy, b2.maxy))
   end
end

function Bounds:expand(dx, dy)
    dy = dy or dx
    
    return Bounds(self.minx-dx, self.miny-dy,
                  self.maxx+dx, self.maxy+dy)
end