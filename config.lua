Config = {
    Locale = 'en',

    Controls = {
        -- FiveM Controls: https://docs.fivem.net/game-references/controls/
        openKey = 214, -- CANC
        goUp = 85, -- Q
        goDown = 48, -- Z
        turnLeft = 34, -- A
        turnRight = 35, -- D
        goForward = 32,  -- W
        goBackward = 33, -- S
        changeSpeed = 21, -- L-Shift
        camMode = 74, -- H
    },

    Speeds = {
        -- You can add or edit existing speeds with relative label
        { label = 'Very Slow', speed = 0},
        { label = 'Slow', speed = 0.5},
        { label = 'Normal', speed = 2},
        { label = 'Fast', speed = 5},
        { label = 'Very Fast', speed = 10},
        { label = 'Max', speed = 15},
    },

    Offsets = {
        y = 0.5, -- Forward and backward movement speed multiplier
        z = 0.2, -- Upward and downward movement speed multiplier
        h = 3, -- Rotation movement speed multiplier
    },

    EnableHUD = true,

    FrozenPosition = false, -- Toggle "frozen" position while noclip is active, enabling his also disables spawning already noclipped vehicles

    DisableWeapons = true, -- Disable weapon wheel and takes weapons away while noclip is active

    -- Permissions management (adding a group or a steam id requires a resource restart [or just wait a regular server restart :-)])

    -- Keep in mind that using commands such as "/setgrup" from esx will not edit database directly but will add aces to the user 
    -- so you still need to wait a bit for autosave to do its job or save the player manually in case you need this immediately

    AllowedGroups = {
        'superadmin',
        'admin',
        'helper',
    },

    AllowedSteamIDs = {
        'steam:11000011192c5de',
    },
}