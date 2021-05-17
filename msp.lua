-- Blightmud MSP support
local mod = {}

local audio_dir = nil
local filetype = nil

-- Call this to set the audio dir
function mod.set_dir(dir)
	core.enable_protocol(90)
	audio_dir = dir
end

-- Call this to set the audio filetype
function mod.set_filetype(suffix)
	filetype = suffix
end

local function info(...)
	local msgs = {...}
	for _,msg in ipairs(msgs) do
		print(cformat("<bblue>[<bwhite>MSP<bblue>]<reset>: %s", msg))
	end
end

local function file_exists(file)
	local f = io.open(file)
	if f then
		f:close()
		return true
	else
		return false
	end
end

local function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

local function get_params(input)
	local inputs = split(input, " ")
	local params = {}
	local sound = table.remove(inputs, 1)
	params["sound"] = sound
	for _,v in ipairs(inputs) do
		local key, value = table.unpack(split(v, "="))
		params[key] = value
	end
	return params
end

-- Enable MSP subneg
core.enable_protocol(90)

local function play(params, play_cb)
	local amplify = 1.0
	local loop = 1
	local sound_file = audio_dir .. "/" .. params["sound"]
	if params["L"] then
		loop = params["L"]
	end
	if params["V"] then
		amplify = params["V"] / 100
	end
	if filetype then
		sound_file = sound_file .. "." .. filetype
	end
	if file_exists(sound_file) then
		if loop <= 0 then
			play_cb(sound_file, { loop=true, amplify=amplify })
		else
			for _=0,loop do
				play_cb(sound_file, { loop=false, amplify=amplify })
			end
		end
	else
		info("No sound for: " .. params["sound"])
	end
end

local triggers = trigger.add_group()
triggers:add("^!!SOUND\\(([\\w\\d= ]+)\\)", {gag=true, raw=true},
	function (m)
		if audio_dir then
			local params = get_params(m[2])
			play(params, audio.play_sfx)
		end
	end
)

triggers:add("^!!MUSIC\\(([\\w\\d= ]+)\\)", {raw=true, gag=true},
	function (m)
		if audio_dir then
			local params = get_params(m[2])
			play(params, audio.play_music)
		end
	end
)

return mod

