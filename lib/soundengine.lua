MusicUtil = require "musicutil"

engine.name = 'ThebangsSong'

local TheBangs = include('lib/thebangs_engine')
local MidiBangs = include("lib/midibangs")

local SoundEngine = {}
SoundEngine.__index = SoundEngine

SoundEngine.SYNTH_COUNT = 4
SoundEngine.MIDI_COUNT = 16

function SoundEngine:getSetParam(id, name)
    local index = name..'_'..id
    if name == 'algo' then
        return function (value)
            params:set(index, TheBangs.options.algoIndexesByName[value])
        end
    else
        return function (value)
            params:set(index, value)
        end
    end
end

function SoundEngine:velocitude(id, velocitude)
    self:getSetParam(id, 'amp')(velocitude)
end

function SoundEngine.new()
    local s = setmetatable({}, SoundEngine)

    s.all_midibangs = {}

    for i = 1, 4 do
        s.all_midibangs[i] = MidiBangs.new(i)
    end
    return s
end

function SoundEngine:addParams()
    for i = 1,SoundEngine.SYNTH_COUNT do
        self:addSynthParams(i)
    end
    for i = 1,SoundEngine.MIDI_COUNT do self:addMidiParams(i) end

    params:add_separator()
    TheBangs.add_voicer_params()
end

function SoundEngine:updateSynth(id)
    if id < 1 then return end
    engine.algoIndex(params:get("algo_"..id))
    engine.amp(params:get("amp_"..id))
    engine.pan(params:get("pan_"..id))
    engine.mod1(params:get("mod1_"..id))
    engine.mod2(params:get("mod2_"..id))
    engine.hz2(params:get("cutoff_"..id))
    engine.attack(params:get("attack_"..id))
    engine.release(params:get("release_"..id))
end

function SoundEngine:addSynthParams(id)
    local num_params = 8
    params:add_group("Synth " .. id, num_params)

    params:add{ type = "option", id = "algo_"..id, name = "Algo", options = TheBangs.options.algoNames, default = 3 }
    params:add{ type = "control", id = "amp_"..id, name = "Amp",controlspec = controlspec.new(0, 1, 'lin', 0, 0.5, '') }
    params:add{ type = "control", id = "pan_"..id, name = "Pan",controlspec = controlspec.new(-1, 1, 'lin', 0, 0, '') }
    params:add{ type = "control", id = "mod1_"..id, name = "Mod1",controlspec = controlspec.new(0, 1, 'lin', 0, 0.5, '%') }
    params:add{ type = "control", id = "mod2_"..id, name = "Mod2",controlspec = controlspec.new(0, 4, 'lin', 0, 1.0, '%') }
    params:add{ type = "control", id = "cutoff_"..id, name = "Cutoff",controlspec = controlspec.new(50, 5000, 'exp', 0, 800, 'hz') }
    params:add{ type = "control", id = "attack_"..id, name = "Attack",controlspec = controlspec.new(0.0001, 10, 'exp', 0, 0.01, 's') }
    -- controlspec.new(0.1,3.2,'lin',0,1.2,'s')
    params:add{ type = "control", id = "release_"..id, name = "Release",controlspec = controlspec.new(0.0001, 10, 'exp', 0, 1.0, 's') }
end

function SoundEngine:addMidiParams(id)
    local num_params = 6
    params:add_group("Midi " .. id, num_params)

    params:add{type="number", id="midiDevice_"..id, name="Device", min = 1, max = 4, default = 1 }
    params:add{type="number", id="midiChannel_"..id, name="Channel", min = 0, max = 16, default = id }
    params:add{type="number", id="midiVelMin_"..id, name="Vel Min", min = 0, max = 127, default = 60 }
    params:add{type="number", id="midiVelMax_"..id, name="Vel Max", min = 0, max = 127, default = 120 }
    -- params:add{type = "control", id = "midiNoteLength_"..id, name = "Note Length", controlspec = controlspec.new(0.0001, 16.0, 'exp', 1/24, 0.25, 'bt')}

    params:add{type = "control", id = "midiNoteLengthMin_"..id, name = "Length Min", controlspec = controlspec.new(0, 16.0, 'lin', 0.01, 1/4, 'bt', 1/24/10)}
    params:add{type = "control", id = "midiNoteLengthMax_"..id, name = "Length Max", controlspec = controlspec.new(0, 16.0, 'lin', 0.01, 1/4, 'bt', 1/24/10)}
end

function SoundEngine:bang_note(noteNumber, synthId, midiId)
    synthId = synthId or 1
    midiId = midiId or 0
    if noteNumber < 0 or noteNumber > 127 then return end

    if synthId > 0 then
        self:updateSynth(synthId)
        local freq = MusicUtil.note_num_to_freq(noteNumber)
        engine.hz(freq)
    end
    if midiId > 0 then
        local deviceId = params:get("midiDevice_"..midiId)
        local vel = math.random(params:get("midiVelMin_"..midiId), params:get("midiVelMax_"..midiId))
        local length = util.linlin(0,1, params:get("midiNoteLengthMin_"..midiId), params:get("midiNoteLengthMax_"..midiId), math.random())
        self.all_midibangs[deviceId]:bang(noteNumber, vel, length, params:get("midiChannel_"..midiId))
    end
end

function SoundEngine:bang_note_hz(noteFreq, synthId, midiId)
    synthId = synthId or 1
    midiId = midiId or 0

    if synthId > 0 then
        self:updateSynth(synthId)
        engine.hz(noteFreq)
    end
    -- need to convert hz to a note to send midi
    -- if midiId > 0 then
    --     local deviceId = params:get("midiDevice_"..midiId)
    --     local vel = math.random(params:get("midiVelMin_"..midiId), params:get("midiVelMax_"..midiId))
    --     local length = util.linlin(0,1, params:get("midiNoteLengthMin_"..midiId), params:get("midiNoteLengthMax_"..midiId), math.random())
    --     self.all_midibangs[deviceId]:bang(noteNumber, vel, length, params:get("midiChannel_"..midiId))
    -- end
end

return SoundEngine