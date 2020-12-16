-- module for creating collections of soft-timers based on a single fast "superclock"

-- via @catfact
-- https://gist.github.com/catfact/614fcea7bd1c6d1fe1cbdd57b4211580

-- this is a simple singleton implementation for test/mockup
-- TODO: allow multiple instances
-- TODO: allow changing the superclock period

local softclock = {}

-- this field represents the period of the superclock, in seconds
softclock.super_period = 1/128

softclock.clocks = {}

-- call this from the superclock
softclock.tick = function()
  if song.is_playing then
    -- increment the global transport and potentially update the measure
    song.transport = song.transport + 1
    if song.transport % song.division == 1 then
      song.measure = song.measure + 1
      song.is_screen_dirty = true
    end

    -- then update all our clocks
    for id, clock in pairs(softclock.clocks) do
      clock.phase_ticks = clock.phase_ticks + 1
      -- asumption: subclock period is > 1 tick
      if clock.phase_ticks > clock.period_ticks then
        -- save the remainder
        -- (this might need to be a while-loop to catch edge cases?)
        clock.phase_ticks = clock.phase_ticks - clock.period_ticks
        -- and fire the event
        -- (maybe it is useful for the event to get the fractional phase, IDK)
        clock.event(clock.phase_ticks)
      end
    end
  end

  -- check if we need to redraw
  if song.is_screen_dirty then
    redraw()
    song.is_screen_dirty = false
  end
end 

softclock.add = function(id, period, event) 
  local c = {} -- new subclock table
  c.phase_ticks = 0
  -- convert argument from seconds to superclock ticks
  c.period_ticks = period / softclock.super_period
  print('adding clock; id ='..id..'; period_ticks='..c.period_ticks)
  c.event = event
  softclock.clocks[id] = c
end 

softclock.remove = function(id) 
  -- TODO
end 

softclock.clear = function() 
  -- TODO
end 

return softclock