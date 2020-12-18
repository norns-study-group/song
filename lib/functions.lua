fn = {}

function fn.cycle(value, min, max)
  if value > max then
    return min
  elseif value < min then
    return max
  else
    return value
  end
end

function rerun()
  norns.script.load(norns.state.script)
end