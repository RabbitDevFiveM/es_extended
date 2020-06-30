local blips = {}

function ESX.UI.Blips.Register(blip)
    if blip.coords == nil then
        print(('[es_extended] [^3WARNING^7] Ignoring on register of blip with name "%s" due to missing coords'):format(ESX.GetOrElse(blip.name, "Blip missing name")))
        return
    end

    local _blip = AddBlipForCoord(blip.coords)
    SetBlipSprite(_blip, ESX.GetOrElse(blip.sprite, 1))
    SetBlipAsShortRange(_blip, true)
    SetBlipDisplay(_blip, ESX.GetOrElse(blip.display, 4))

    if blip.scale then
        SetBlipScale(_blip, ESX.GetOrElse(blip.scale, 0.5))
    end

    SetBlipColour(_blip, ESX.GetOrElse(blip.colour, 1))
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(ESX.GetOrElse(blip.name, "Blip missing name"))
    EndTextCommandSetBlipName(_blip)

    blips[ESX.GetOrElse(blip.id, #blips + 1)] = {
        _blip = _blip,
        blip = blip
    }
end

function ESX.UI.Blips.Update(blip)
    if blip.id == nil or blips[blip.id] == nil then
        return
    end

    local _blip = blips[blip.id]._blip

    if blip.coords then
        if _blip and GetBlipCoords(_blip) ~= blip.coords then
            RemoveBlip(_blip)
            local tempBlip = blips[blip.id].blip
            blips[blip.id] = nil
            tempBlip.coords = blip.coords
            tempBlip.display = blip.display
            ESX.UI.Blips.Register(tempBlip)
            return
        end
    end

    if blip.sprite then
        SetBlipSprite(_blip, blip.sprite)
    end

    if blip.display then
        SetBlipDisplay(_blip, blip.display)
    end

    if blip.scale then
        SetBlipScale(_blip, ESX.GetOrElse(blip.scale, 0.5))
    end

    if blip.colour then
        SetBlipScale(_blip, blip.colour)
    end

    if blip.name then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blip.name)
        EndTextCommandSetBlipName(_blip)
    end
end
