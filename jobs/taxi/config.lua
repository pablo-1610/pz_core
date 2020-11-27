TaxiJob_Config = {
    clothes = {
        [1] = {
            label = "Tenue de taxi",
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
    },

    vehicles = {
        {model = "taxi", label = "Taxi"},
        {model = "schafter4", label = "Uber"}
    }
}

pzCore.jobs["taxi"] = {}
pzCore.jobs["taxi"].config = TaxiJob_Config