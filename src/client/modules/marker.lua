local markers, drawingMarkers, CurrentMarker, HasAlreadyEnteredMarker = {}, {}, nil, nil

function ESX.UI.Markers.Register(marker)
    if marker.coords == nil then
        print(('[es_extended] [^3WARNING^7] Ignoring on register of marker with name "%s" due to missing coords'):format(marker.name))
        return
    end

    if marker.shouldDraw == nil then
        marker.shouldDraw = function()
            return true
        end
    else
        marker.shouldDraw()
    end

    if Config.EnableDebug then
        print(('[es_extended] [^2INFO^7] Registering a marker with name "%s^7"'):format(marker.name))
    end

    if markers[marker.name] ~= nil then
        marker.changed = true
        markers[marker.name] = marker
    elseif marker.name ~= nil then
        markers[marker.name] = marker
    else
        table.insert(marker.name)
    end
end

function ESX.UI.Markers.Unregister(name)
    markers[name] = nil
    drawingMarkers[name] = nil
end

function ESX.UI.Markers.Enter(marker)
    if marker.show3D then
        PlaySound(GetSoundId(), "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    end

    CurrentMarker = marker
end

function ESX.UI.Markers.Exit()
    CurrentMarker = nil
    ESX.UI.Menu.CloseAll()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local isInMarker = false
        local lastMarker
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        for k, v in pairs(markers) do
            if v.shouldDraw() then
                local distance = #(coords - v.coords)
                if (drawingMarkers[k] == nil or v.changed) and distance <= Config.DrawDistance then
                    markers[k].changed = false
                    drawingMarkers[k] = v
                elseif drawingMarkers[k] ~= nil then
                    drawingMarkers[k].distance = distance
                    if distance > Config.DrawDistance then
                        drawingMarkers[k] = nil
                    end
                end
                if distance < v.size.x then
                    if v.enableE then
                        EnableControlAction(0, 38)
                    end
                    isInMarker = true
                    lastMarker = v
                end
            end
        end

        if isInMarker and not HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = true
            ESX.Markers.Enter(lastMarker)
        end
        if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            ESX.Markers.Exit()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(drawingMarkers) do
            if v.show3D then
                if v.distance ~= nil and v.distance <= Config.Draw3DDistance then
                    ESX.Game.Utils.DrawText3D(v.coords, v.msg, 0.5)
                end
            elseif v.type ~= -1 then
                DrawMarker(v.type, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.size.x, v.size.y, v.size.z, v.colour.r, v.colour.g, v.colour.b, 100, ESX.GetOrElse(v.bob, false), true, 2, ESX.GetOrElse(v.rotate, true), false, false, false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentMarker then
            if not CurrentMarker.show3D and CurrentMarker.msg then
                ESX.ShowHelpNotification(CurrentMarker.msg)
            end

            if IsControlJustReleased(0, 38) then
                if CurrentMarker.action ~= nil then
                    CurrentMarker.action(CurrentMarker)
                end
            end
        end
    end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        ESX.UI.Markers.Exit()
    end
end)
