-- graphics library abstracting all screen functions

local graphics = {}

function graphics.init()
  screen.aa(0)
  screen.font_face(0)
  screen.font_size(8)
end

function graphics:setup()
  screen.clear()
end

function graphics:teardown()
  screen.update()
  screen.ping()
end

function graphics:draw_measure()
  local width = 3
  local x = 128 - width
  local y = 1
  for i = 1, song.denominator do
    self:rect(x, i * (y + width) - width, width, width, (i == song.numerator) and 15 or 1)
    if song.numerator == 1 then
      self:mlrs(x - 2, 1, 1, song.denominator * (width + 1), 15)
    end
  end
end

function graphics:mlrs(x1, y1, x2, y2, l)
  screen.level(l or 15)
  screen.move(x1, y1)
  screen.line_rel(x2, y2)
  screen.stroke()
end

function graphics:mls(x1, y1, x2, y2, l)
  screen.level(l or 15)
  screen.move(x1, y1)
  screen.line(x2, y2)
  screen.stroke()
end

function graphics:rect(x, y, w, h, l)
  screen.level(l or 15)
  screen.rect(x, y, w, h)
  screen.fill()
end

function graphics:circle(x, y, r, l)
  screen.level(l or 15)
  screen.circle(x, y, r)
  screen.fill()
end

function graphics:text(x, y, s, l)
  screen.level(l or 15)
  screen.move(x, y)
  screen.text(s)
end

function graphics:text_right(x, y, s, l)
  screen.level(l or 15)
  screen.move(x, y)
  screen.text_right(s)
end

function graphics:text_center(x, y, s, l)
  screen.level(l or 15)
  screen.move(x, y)
  screen.text_center(s)
end

function graphics:text_rotate(x, y, s, d, l)
  screen.level(l or 15)
  screen.text_rotate(x, y, s, d)
end

function graphics:text_center_rotate(x, y, s, d, l)
  screen.level(l or 15)
  screen.text_center_rotate(x, y, s, d)
end

function graphics:bez(x1, y1, x2, y2, x3, y3)
  screen.curve(x1, y1, x2, y2, x3, y3)
  screen:stroke ()
end

return graphics