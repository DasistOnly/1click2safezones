local safeZones = {}

function CreateSafeZone(x, y, z, radius)
    table.insert(safeZones, {x = x, y = y, z = z, radius = radius})
end

CreateThread(function()
    for i, safeZone in ipairs(safeZones) do
        local blip = AddBlipForRadius(safeZone.x, safeZone.y, safeZone.z, safeZone.radius)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, 128)
    end
end)

for i, safeZone in ipairs(CL.Safezones) do
    CreateSafeZone(safeZone.x, safeZone.y, safeZone.z, safeZone.radius)
end

CreateThread(function()
    while true do
        Wait(10)
        local isInSafeZone = false
        local playerCoords = GetEntityCoords(PlayerPedId())
        for i, safeZone in ipairs(safeZones) do
            if #(vector3(safeZone.x, safeZone.y, safeZone.z) - playerCoords) < safeZone.radius then
                isInSafeZone = true

                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 47, true) 
                DisableControlAction(0, 58, true) 
                DisableControlAction(0, 263, true) 
                DisableControlAction(0, 264, true) 
                DisableControlAction(0, 257, true) 
                DisableControlAction(0, 140, true) 
                DisableControlAction(0, 141, true) 
                DisableControlAction(0, 142, true) 
                DisableControlAction(0, 143, true) 
                SetEntityInvincible(PlayerPedId(), true)
                SetEntityCanBeDamaged(PlayerPedId(), false)
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if DoesEntityExist(vehicle) then
                    SetEntityMaxSpeed(vehicle, CL.Speedlimit)
                    end
                break
            end
        end
        if not isInSafeZone then
            SetEntityInvincible(PlayerPedId(), false)
            SetEntityCanBeDamaged(PlayerPedId(), true)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if DoesEntityExist(vehicle) then
                SetEntityMaxSpeed(vehicle, math.huge)
            end
        end
    end
end)