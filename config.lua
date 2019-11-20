Config = {}
Config.DrawDistance = 10.0
Config.EnableHouses = true
Config.EnableCondominiums = true
Config.EnableMotels = true

Config.Blips = {
    -- Condominiums
    Condominiums = {
        Available = {Sprite = 476, Display = 4, Scale = 1.0, Colour = 0},
        Owned = {Sprite = 475, Display = 4, Scale = 1.0, Colour = 0}
    },
    -- Houses
    Houses = {
        Available = {Sprite = 350, Display = 4, Scale = 1.0, Colour = 0},
        Owned = {Sprite = 40, Display = 4, Scale = 1.0, Colour = 0}
    },
    -- Motels
    Motels = {Sprite = 476, Display = 4, Scale = 1.0, Colour = 0}
}

Config.Markers = {
    Enter = {
        Type = 27,
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Colour = {r = 50, g = 50, b = 50},
        Alpha = 150
    },
    Exit = {
        Type = 27,
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Colour = {r = 50, g = 50, b = 50},
        Alpha = 150
    },
    GarageGet = {
        Type = 27,
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Colour = {r = 50, g = 50, b = 50},
        Alpha = 150
    },
    GaragePut = {
        Type = 27,
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Colour = {r = 50, g = 50, b = 50},
        Alpha = 150
    }
}
