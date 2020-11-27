FbiJob_Config = {
    outfit = {
        [0] = {
            grade = "recruit", -- 1
            label = "recrue",
            male = {
                tshirt_1 = 59,  tshirt_2 = 1,
                torso_1 = 55,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 41,
                pants_1 = 25,   pants_2 = 0,
                shoes_1 = 25,   shoes_2 = 0,
                helmet_1 = 46,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            },
            female = {
                tshirt_1 = 36,  tshirt_2 = 1,
                torso_1 = 48,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 44,
                pants_1 = 34,   pants_2 = 0,
                shoes_1 = 27,   shoes_2 = 0,
                helmet_1 = 45,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },

        [1] = {
            grade = "boss", -- 1
            label = "boss",
            male = {
                tshirt_1 = 59,  tshirt_2 = 1,
                torso_1 = 55,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 41,
                pants_1 = 25,   pants_2 = 0,
                shoes_1 = 25,   shoes_2 = 0,
                helmet_1 = 46,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            },
            female = {
                tshirt_1 = 36,  tshirt_2 = 1,
                torso_1 = 48,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 44,
                pants_1 = 34,   pants_2 = 0,
                shoes_1 = 27,   shoes_2 = 0,
                helmet_1 = 45,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        }
    },

    weapons = {
        [1] = {weapon = "WEAPON_STUNGUN", label = "Pistolet paralysant", minGrade = 0},
        [2] = {weapon = "WEAPON_NIGHTSTICK", label = "Baton téléscopique",  minGrade = 0},
        [3] = {weapon = "WEAPON_COMBATPISTOL", label = "Pistolet 9mn",  minGrade = 0},
        [4] = {weapon = "WEAPON_PUMPSHOTGUN", label = "Fusil à pompe",  minGrade = 0},
        [5] = {weapon = "weapon_carbinerifle", label = "Fusil d'assault",  minGrade = 0},
        [6] = {weapon = "weapon_sniperrifle", label = "Fusil de précision",  minGrade = 0},
	}
}

pzCore.jobs["fbi"] = {}
pzCore.jobs["fbi"].config = FbiJob_Config