jobsMarkers = {
    
    subscribe = function()
        local playerJob = ESX.PlayerData.job.name
        if jobsMarkers.list[playerJob] == nil then return end 

        for job,marker in pairs(jobsMarkers.list[playerJob]) do
            pzCore.markers.subscribe(marker)
        end
    end,

    unsubscribe = function()
        local playerJob = ESX.PlayerData.job.name
        if jobsMarkers.list[playerJob] == nil then return end 

        for job,marker in pairs(jobsMarkers.list[playerJob]) do
            pzCore.markers.unsubscribe(marker)
        end
    end,

    unsubscribeAll = function()
        for job,marker in pairs(jobsMarkers.list) do
            for _,a in pairs(jobsMarkers.list[job]) do 
                pzCore.markers.unsubscribe(a)
            end
        end
    end,


    list = {
        ["police"] = {
            "police_clothes",
            "police_armory",
            "police_vehicle",
            "police_vehicleClear",
            "police_helicopter",
            "police_boss"
        },

        ["fbi"] = {
            "fbi_vehicle",
            "fbi_vehicleClear",
            "fbi_armory",
            "fbi_boss"
        },

        ["unicorn"] = {
            "unicorn_bar_entry",
            "unicorn_bar_exit",
            "unicorn_barman",
            "unicorn_boss",
            "unicorn_clothes",
            "unicorn_garage",
            "unicorn_vehicleClear"
        },

        ["bahamas"] = {
            "bahamas_bar_entry",
            "bahamas_bar_exit",
            "bahamas_barman",
            "bahamas_boss",
            "bahamas_clothes",
            "bahamas_garage",
            "bahamas_vehicleClear"
        },

        ["taxi"] = {
            "taxi_vehicleClear",
            "taxi_garage",
            "taxi_boss",
            "taxi_clothes"
        },

        ["vigne"] = {
            "vigneron_vehicle",
            "vigneron_vehicleClear",
            "vigneron_boss",
            "vigneron_clothes",
            "vigneron_inventory"
        }
    },
}

pzCore.jobsMarkers = jobsMarkers