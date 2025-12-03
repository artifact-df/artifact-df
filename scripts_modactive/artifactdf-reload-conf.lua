--@ module = true
--
-- This script serves both as an init script for ArtifactDF and a command to reload its config file

local artifact_core = reqscript("internal/artifactdf/core")

if dfhack_flags.module then
    local artifact_modules = {
        -- Add any internal modules that need to load on startup here, e.g. those that register events
        "projectiles",
    }
    for _, mod in pairs(artifact_modules) do
        reqscript("internal/artifactdf/" .. mod)
    end
end

-- Reload the config file
artifact_core.reloadSettings()
