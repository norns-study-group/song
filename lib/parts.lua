-- never tried this before... a table for organizing "composed" musical parts
-- verses, choruses, bridges, melodies, generative things...?

local parts = {}

function parts.init()
  -- parts.whatever_we_need = 0
end

function parts:whole_notes(phase)
  print("do a whole notes thing", phase)
  engine.amp(1)
  engine.hz(440)
  if song.measure == 100 then
    engine.hz(293.665)
  elseif song.measure % 4 == 1 then
    engine.hz(587.33)
  elseif song.measure % 15 == 1 then
    engine.hz(659.255)
  end
end

function parts:quarter_notes(phase)
  print("do a quarter_notes thing", phase)
  if math.random(1, 2) == 1 then
    engine.amp(.5)
    engine.hz(880)
  end
end

function parts:dotted_half_notes(phase)
  print("do a dotted_half_notes thing", phase)
end

function parts:crazy_part(phase)
  print("do a crazy_part thing", phase)
end


return parts