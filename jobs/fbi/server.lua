RegisterNetEvent("pz_core:adrGet")
AddEventHandler("pz_core:adrGet", function()
    local _src = source
    local table = {}
    print("ADR GET TRIGGERED")
    MySQL.Async.fetchAll('SELECT * FROM adr', {}, function(result)
        for k,v in pairs(result) do
            table[v.id] = v
        end
        TriggerClientEvent("pz_core:adrGet", _src, table)
    end)
end)

RegisterNetEvent("pz_core:adrDel")
AddEventHandler("pz_core:adrDel", function(id)
    local _src = source

    MySQL.Async.execute('DELETE FROM adr WHERE id = @id',
    { ['id'] = id },
    function(affectedRows)
        TriggerClientEvent("pz_core:adrDel", _src)
    end
    )
end)

RegisterNetEvent("pz_core:adrAdd")
AddEventHandler("pz_core:adrAdd", function(builder)
    local _src = source
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
    MySQL.Async.execute('INSERT INTO adr (author,date,firstname,lastname,reason,dangerosity) VALUES (@a,@b,@c,@d,@e,@f)',

    { 
        ['a'] = GetPlayerName(_src) ,
        ['b'] = date,
        ['c'] = builder.firstname,
        ['d'] = builder.lastname,
        ['e'] = builder.reason,
        ['f'] = builder.dangerosity
    },


    function(affectedRows)
        TriggerClientEvent("pz_core:adrAdd", _src)
    end
    )
end)


