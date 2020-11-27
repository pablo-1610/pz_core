local function init()
    for _,job in pairs(pzCore.jobs) do 
        if job.createBlip ~= nil then job.createBlip() end
    end

    local job = ESX.PlayerData.job.name
    if pzCore.jobs[job] ~= nil then 
        pzCore.jobs[job].init() 
    end
end

local function changed()
    for k,v in pairs(pzCore.jobs) do if v.jobChanged ~= nil then v.jobChanged() end end
end

pzCore.jobs = {}
pzCore.jobsFunc = {}
pzCore.jobsFunc.init = init
pzCore.jobsFunc.changed = changed