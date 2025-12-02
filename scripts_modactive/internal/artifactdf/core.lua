--@ module = true
--
-- This script is for global functions and constants used throughout Artifact DF.

local json = require("json")

--
-- Console printing
--
function print(string)
	dfhack.color(COLOR_LIGHTMAGENTA)
	dfhack.println("*Artifact DF*: " .. string)
	dfhack.color()
end

function printDebug(string)
	if settings.DEBUG_ENABLED then
		dfhack.color(COLOR_MAGENTA)
		dfhack.println("*Artifact DF* DEBUG INFO: " .. string)
		dfhack.color()
	end
end

--
-- Config file
--
settings = {
	DEBUG_ENABLED = false,
	DISABLE_GUN_SMOKE = false,
	REDUCE_GUN_SMOKE = false,
}

function reloadSettings()
	local file = io.open("ArtifactDF.conf", "r")
	if file ~= nil then
		print("Loaded Artifact DF config file")
		settings = json.decode(file:read("*all"))
		file:close()
		return true
	else
		print("Creating default Artifact DF config file")
		file = io.open("ArtifactDF.conf", "w")
		file:write(json.encode(settings))
		file:close()
		return false
	end
end

reloadSettings()
