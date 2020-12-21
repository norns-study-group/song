-- module for creating collections of soft-timers based on a single fast "superclock"

-- via @catfact
-- https://gist.github.com/catfact/614fcea7bd1c6d1fe1cbdd57b4211580

-- this is a simple singleton implementation for test/mockup
-- TODO: allow multiple instances
-- TODO: allow changing the superclock period

local softclock = {}

function softclock.init()
  -- this field represents the period of the superclock in ppqn
  softclock.super_period = 96
  softclock.transport = 0
  softclock.song_clocks = {}
  softclock.sources = {}
  softclock.sources[1] = "internal"
  softclock.sources[2] = "midi"
  softclock.sources[3] = "link"
  softclock.sources[4] = "crow"
end

function softclock.super_tick()
  while true do
    clock.sync(1 / softclock.super_period)
    softclock.transport = softclock.transport + 1

    if song.is_playing then

      if softclock.transport % softclock.super_period == 1 then
        song.numerator = fn.cycle(song.numerator + 1, 1, song.denominator)
        song.is_screen_dirty = true
      end

      if softclock.transport % (softclock.super_period * song.denominator) == 1 then
        song.measure = song.measure + 1
        song.is_screen_dirty = true
      end

      -- then update all our clocks
      for id, song_clock in pairs(softclock.song_clocks) do
        song_clock.phase_ticks = song_clock.phase_ticks + 1
        -- asumption: subclock period is > 1 tick
        if song_clock.phase_ticks > song_clock.period_ticks then
          -- save the remainder
          -- (this might need to be a while-loop to catch edge cases?)
          song_clock.phase_ticks = song_clock.phase_ticks - song_clock.period_ticks
          -- and fire the event
          -- (maybe it is useful for the event to get the fractional phase, IDK)
          song_clock.event(song_clock.phase_ticks)
        end
      end
    end

    -- check if we need to redraw
    if song.is_screen_dirty then
      redraw()
      song.is_screen_dirty = false
    end
  end
end 

function softclock:add(id, period, event) 
  local c = {} -- new subclock table
  c.phase_ticks = 0
  -- convert argument from seconds to superclock ticks
  c.period_ticks = period / (1 / self.super_period) * song.denominator
  print('adding song_clock; id ='..id..'; period_ticks='..c.period_ticks)
  c.event = event
  self.song_clocks[id] = c
end 

function softclock:remove(id) 
  -- TODO
end 

function softclock:clear () 
  -- TODO
end 

return softclock