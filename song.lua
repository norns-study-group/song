-- k1: exit  e1: ???
--
--
--      e2: ???      e3: ???
--
--
--    k2: start    k3: restart

-- engine.name = "PolyPerc" -- standard issue... for now?!?!
song = {} -- our song
softclock = include("lib/softclock") -- global clock
parts = include("lib/parts") -- musical things
graphics = include("lib/graphics") -- graphics library
local SoundEngine = include("lib/soundengine")

local sound_engine = nil

local function super_tick()
  softclock.tick()
end 

function init()
  sound_engine = SoundEngine.new()

  sound_engine:addParams()

  parts.init(sound_engine)
  graphics.init()
  song.is_screen_dirty = true
  song.is_playing = true
  song.transport = 0
  song.measure = 0
  song.division = 8
  super_metro = metro.init{
    time = 1 / song.division,
    event= super_tick
  }
  softclock.super_period = 1 / song.division
  -- add independent clocks here and their respective parts here
  softclock.add('a', 1, function(phase) parts:whole_notes(phase) end)
  softclock.add('b', 1/4, function(phase) parts:quarter_notes(phase) end)
  softclock.add('c', 3/4, function(phase) parts:dotted_half_notes(phase) end)
  softclock.add('d', 11/17, function(phase) parts:crazy_part(phase) end)
  softclock.add('e', 1/16, function(phase) parts:sixteenth_notes(phase) end)
  super_metro:start()
  redraw()
end

function redraw()
  graphics:setup()
  graphics:rect(1, 1, 7, 64, 15)
  graphics:text_rotate(7, 62, "SONG", -90, 0)
  graphics:text(10, 7, (song.is_playing == true) and "PLAYING" or "STOPPED", 15)
  graphics:text(10, 14, "MEASURE: " .. song.measure, 15)
  legalGraphics()
  illegalGraphics()
  checkIfNice()
  graphics:teardown()
end

function key(k, z)
  if z == 0 then return end
  if k == 1 then
    print("k1: ???")
  elseif k == 2 then
    song.is_playing = not song.is_playing
  elseif k == 3 then
    song.measure = 0
  end
  song.is_screen_dirty = true
end

function legalGraphics()
  if (song.measure%4 == 0) then
    bright = song.measure%15
    radness = song.measure%9-song.measure%2
    graphics:circle(64,32,radness,bright)
   end
  if (song.measure%3==0 and song.measure%7==0) then
    graphics:bez(100,60,0,80,100,119)
    end
end

function illegalGraphics()
if (song.measure>=420 and song.measure<430) then
    graphics:text(10, 28, "these measures ", 15)
    graphics:text(10, 35, "are illegal to ", 15)
    graphics:text(10, 42, "inhale ", 15)
  end
end

function checkIfNice()
  if (song.measure==69) then
    graphics:text(10, 21, "nice", 15)
    end
end

function enc(e, d)
  print(e, d, "???")
  song.is_screen_dirty = true
end

function rerun()
  norns.script.load(norns.state.script)
end