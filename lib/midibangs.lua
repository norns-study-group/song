-- Class for sending out midi bangs

local MidiBangs = {}
MidiBangs.__index = MidiBangs

function MidiBangs.new(deviceId)
    deviceId = deviceId or 1

    local m = setmetatable({}, MidiBangs)

    m.midi = midi.connect(deviceId)

    m.active_notes = {}

    for i = 1, 16 do
        m.active_notes[i] = {}
    end

    m.clock_id = clock.run(function() MidiBangs.loop(m) end)

    return m
end

function MidiBangs:loop()
    local syncTime = 1/24

    while true do
        clock.sync(syncTime)

        for i = 1, 16 do
            local removeIndices = {}

            for j, m in pairs(self.active_notes[i]) do
                m.time = m.time - syncTime
                if m.time <= 0 then
                    self.midi:note_off(j, 0, i)
                    table.insert(removeIndices, j)
                end
            end

            for j, v in pairs(removeIndices) do
                self.active_notes[i][j] = nil
            end
        end
    end
end

-- length is in beattime, 1 = 1 quater note, 4 = 1 bar
function MidiBangs:bang(noteNumber, vel, length, channel)
    noteNumber = noteNumber or 60
    vel = vel or 100
    length = length or 1
    channel = channel or 1
    if channel < 1 or channel > 16 then return end
    if noteNumber < 0 or noteNumber > 127 then return end

    if self.active_notes[channel][noteNumber] ~= nil then
        self.midi:note_off(noteNumber, 0, channel)
    end

    self.midi:note_on(noteNumber, vel, channel)

    self.active_notes[channel][noteNumber] = {
        time = length,
        vel = vel
    }
end

return MidiBangs