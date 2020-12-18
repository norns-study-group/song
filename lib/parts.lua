-- never tried this before... a table for organizing "composed" musical parts
-- verses, choruses, bridges, melodies, generative things...?


local parts = {}

function parts.init(soundEngine)
  parts.soundEngine = soundEngine
  parts.quarter_beat = 0
  parts.sixteenth_beat = 0

  parts.drumPat = 1

  parts.drums = {}

  for i = 1, 16 do
    parts.drums[i] = {}
    parts.drums[i].kick = {}
    parts.drums[i].snare = {}
    parts.drums[i].hh = {}
  end

  parts.drums[2].kick = {1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0}

  parts.drums[3].hh = {
    0,0,1,0,
    0,0,1,0,
    0,0,1,0,
    0,0,1,0}

  parts.drums[4].kick = {
    1,0,1,0,
    0,0,0,0,
    1,0,0,0,
    0,0,1,0}
  parts.drums[4].snare = {
    0,0,0,0,
    1,0,0,0,
    0,0,0,0,
    1,0,0,0}
  parts.drums[4].hh = {
    1,0,1,0,
    1,0,1,0,
    1,0,1,0,
    1,0,1,0}

  -- parts.whatever_we_need = 0
end

function parts:whole_notes(phase)
  print("do a whole notes thing", phase)

  self.soundEngine:bang_note(69, 2, 0)

  if song.measure == 8 then self.drumPat = 2 
  elseif song.measure == 16 then self.drumPat = 3
  elseif song.measure == 24 then self.drumPat = 4 end

  if song.measure == 100 then
    self.soundEngine:bang_note(62, 1, 0)
  elseif song.measure % 4 == 1 then
    self.soundEngine:bang_note(62, 1, 0)
  elseif song.measure % 15 == 1 then
    self.soundEngine:bang_note(76, 1, 0)
  end
end

function parts:quarter_notes(phase)
  print("do a quarter_notes thing", phase)
  if math.random(1, 2) == 1 then
    self.soundEngine:bang_note(81, 2, 0)
  end
  self.quarter_beat = self.quarter_beat+1
  local beat = self.quarter_beat
  if beat>32 then
    -- rest
    elseif beat%31==0 then self.soundEngine:bang_note(59, 1, 0)
    elseif beat%29==0 then self.soundEngine:bang_note(60, 1, 0)
    elseif beat%27==0 then self.soundEngine:bang_note(55, 1, 0)
    elseif beat%25==0 then self.soundEngine:bang_note(52, 1, 0)
    elseif beat%23==0 then self.soundEngine:bang_note(52, 1, 0)
    elseif beat%21==0 then self.soundEngine:bang_note(52, 1, 0)
    elseif beat%17==0 then self.soundEngine:bang_note(48, 1, 0)
    elseif beat%15==0 then self.soundEngine:bang_note(52, 1, 0)
    elseif beat%11==0 then self.soundEngine:bang_note(52, 1, 0)
    elseif beat%9==0 then self.soundEngine:bang_note(47, 1, 0)
    elseif beat%7==0 then self.soundEngine:bang_note(52, 1, 0)
    elseif beat%5==0 then self.soundEngine:bang_note(52, 1, 0)
    elseif beat%1==0 then self.soundEngine:bang_note(45, 1, 0)
  end
end

function parts:sixteenth_notes(phase)
  self.sixteenth_beat = self.sixteenth_beat+1
  local beat = self.sixteenth_beat
  if beat<64 then
    -- nothing
    elseif beat%31==0 then self.soundEngine:bang_note(71, 1, 0)
    elseif beat%29==0 then self.soundEngine:bang_note(72, 1, 0)
    elseif beat%27==0 then self.soundEngine:bang_note(67, 1, 0)
    elseif beat%25==0 then self.soundEngine:bang_note(64, 1, 0)
    elseif beat%23==0 then self.soundEngine:bang_note(64, 1, 0)
    elseif beat%21==0 then self.soundEngine:bang_note(64, 1, 0)
    elseif beat%17==0 then self.soundEngine:bang_note(60, 1, 0)
    elseif beat%15==0 then self.soundEngine:bang_note(64, 1, 0)
    elseif beat%11==0 then self.soundEngine:bang_note(64, 1, 0)
    elseif beat%9==0 then self.soundEngine:bang_note(59, 1, 0)
    elseif beat%7==0 then self.soundEngine:bang_note(64, 1, 0)
    elseif beat%5==0 then self.soundEngine:bang_note(64, 1, 0)
    elseif beat%1==0 then self.soundEngine:bang_note(57, 1, 0)
  end

  local noteIndex = (self.sixteenth_beat % 16) + 1

  local pat = self.drums[self.drumPat]

  if pat.kick[noteIndex] == 1 then
    self.soundEngine:bang_note(32, 4, 0)
  end

  if pat.snare[noteIndex] == 1 then
    self.soundEngine:bang_note(38, 5, 0)
  end

  if pat.hh[noteIndex] == 1 then
    self.soundEngine:bang_note(60, 6, 0)
  end
end

function parts:dotted_half_notes(phase)
  print("do a dotted_half_notes thing", phase)
end

function parts:crazy_part(phase)
  print("do a crazy_part thing", phase)
end


return parts