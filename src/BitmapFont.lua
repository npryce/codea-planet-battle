
BitmapFont = class()
    
function BitmapFont:init(fontData)
    self.glyphs = {}
    for key, data in pairs(fontData) do
        if #key == 1 then
            self.glyphs[key] = self:parseGlyph(data)
        else
            self[key] = data
        end
    end
end

function BitmapFont:parseGlyph(glyphData)
    local height = #glyphData
    
    local width = 0
    for _,line in pairs(glyphData) do
        width = math.max(width, #line)
    end
    
    return {
        height = height,
        width = width,
        data = glyphData
    }
end

function BitmapFont:render(text, renderPixel)
    renderPixel = renderPixel or SimpleFontStyle()
    
    local px = 0
    local lineIndex = 1
    local charIndex = 1
    
    for i = 1, #text do
        local ch = string.sub(text,i,i)
        if ch == '\n' then
            lineIndex = lineIndex + 1
            charIndex = 1
            px = 0
        else
            local glyph = self.glyphs[ch]
        
            if glyph ~= nil then
                self:renderGlyph(glyph, lineIndex, charIndex, px, renderPixel)
                charIndex = charIndex + 1
                px = px + glyph.width + self.charSpacing
            end
        end
    end
end

function BitmapFont:renderGlyph(glyph, lineIndex, charIndex, px, renderPixel)
    local baseline = glyph.baseline or self.baseline or 0
    
    for gy, line in ipairs(glyph.data) do
        for gx = 1,#line do
            local pixel = string.sub(line, gx, gx)
            if pixel ~= " " then
                local x = px + gx-1
                local y = (glyph.height-gy)+baseline - 
                    (lineIndex-1)*(self.height+self.lineSpacing)
                renderPixel(lineIndex, charIndex, x, y, pixel)
            end
        end
    end
end

function SimpleFontStyle(args)
    local size = args and args.size or 1

    return function(lineIndex, charIndex, x, y, pixelCode)
        rect(x*size, y*size, size, size)
    end
end
