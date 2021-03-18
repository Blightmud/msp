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

local triggers = trigger.add_group()
triggers:add("^!!SOUND\\(([\\w\\d= ]+)\\)", {gag=true, raw=true},
	function (m)
		if audio_dir then
			local params = get_params(m[2])
			local sound_file = audio_dir .. "/" .. params["sound"]
			if filetype then
				sound_file = sound_file .. "." .. filetype
			end
			if file_exists(sound_file) then
				audio.play_sfx(sound_file)
			else
				info("No sound for: " .. params["sound"])
			end
		end
	end
)

triggers:add("^!!MUSIC\\(([\\w\\d= ]+)\\)", {raw=true, gag=true},
	function (m)
		if audio_dir then
			local params = get_params(m[2])
			local sound_file = audio_dir .. "/" .. params["sound"]
			if filetype then
				sound_file = sound_file .. "." .. filetype
			end
			if file_exists(sound_file) then
				audio.play_music(sound_file, true)
			else
				info("No sound for: " .. params["sound"])
			end
		end
	end
)

return mod

