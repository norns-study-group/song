-- k1: exit  e1: ???
--
--
--      e2: tempo      e3: ???
--
--
--    k2: start    k3: restart

song = {} -- our song
include("lib/functions") -- global functions
softclock = include("lib/softclock") -- global clock
parts = include("lib/parts") -- musical things
graphics = include("lib/graphics") -- graphics library
local SoundEngine = include("lib/soundengine")

local sound_engine = nil

function init()
  sound_engine = SoundEngine.new()
  sound_engine:addParams()
  sound_engine:setSynthParams(4, {algo=4, amp=1.0, pan=0, mod1 = 0.2, mod2 = 1.0, cutoff=800, attack=0, release=0.16})
  sound_engine:setSynthParams(5, {algo=6, amp=0.8, pan=0, mod1 = 0.9, mod2 = 1.68, cutoff=2400, attack=0, release=0.35})
  sound_engine:setSynthParams(6, {algo=7, amp=0.5, pan=0, mod1 = 0.8, mod2 = 2.64, cutoff=3300, attack=0.001, release=0.03})
  parts.init(sound_engine)
  graphics.init()
  softclock.init()
  song.is_screen_dirty = true
  song.is_playing = true
  song.measure = 0
  -- who needs music theory when math?
  song.numerator = 0
  song.denominator = 4
  -- add independent clocks here and their respective parts here
  softclock:add('a', 1, function(phase) parts:whole_notes(phase) end)
  softclock:add('b', 1/4, function(phase) parts:quarter_notes(phase) end)
  softclock:add('c', 1/16, function(phase) parts:sixteenth_notes(phase) end)
  song._clock_id = clock.run(softclock.super_tick)
  redraw()
end

function redraw()
  graphics:setup()
  graphics:rect(1, 1, 7, 64, 15)
  graphics:text_rotate(7, 62, "SONG", -90, 0)
  graphics:text_right(64, 7, "STATUS:", 15)
  graphics:text(70, 7, (song.is_playing == true) and "PLAYING" or "STOPPED", 15)
  graphics:text_right(64, 14, "MEASURE: ", 15)
  graphics:text(70, 14, song.measure, 15)
  graphics:text_right(64, 21, "BPM (E2): ", 15)
  graphics:text(70, 21, params:get("clock_tempo"), 15)
  graphics:text_right(64, 28, "SOURCE: ", 15)
  graphics:text(70, 28, string.upper(softclock.sources[params:get("clock_source")]), 15)
  graphics:draw_measure()
  graphics:legalGraphics()
  graphics:illegalGraphics()
  graphics:checkIfNice()
  graphics:thankUser()
  graphics:teardown()
end

function key(k, z)
  if z == 0 then return end
  if k == 1 then
    print("k1: ???")
  elseif k == 2 then
    song.is_playing = not song.is_playing
  elseif k == 3 then
    resetSong()
  end
  song.is_screen_dirty = true
end

function enc(e, d)
  print(e, d, "???")
  if e == 2 then
    params:set("clock_tempo", util.clamp((params:get("clock_tempo") + d), 20, 300))
  end
  song.is_screen_dirty = true
end


function resetSong()
    song.measure = 0
    parts.quarter_beat = 0
    parts.sixteenth_beat = 0
end

function cleanup()
  _midi:all_off()
  clock.cancel(song._clock_id)
end