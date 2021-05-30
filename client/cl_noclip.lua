local NoClipActive = false
local NoClipEntity
local timer

Citizen.CreateThread(function()
    while true do 
        if IsControlJustPressed(1, Config.Controls.openKey) then
            if NoClipActive then
                TriggerEvent('admin:toggleNoClip')
            else
                timer = 5000
                TriggerServerEvent('admin:noClip')
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()

    local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(100)
    end
    
    local index = 1
    local CurrentSpeed = Config.Speeds[index].speed
    local FollowCamMode = true

    while true do
        while NoClipActive do
            if not IsHudHidden() and Config.EnableHUD and timer > 0 then
                timer = timer - 10
                RenderScale(scaleform, index, FollowCamMode)          
            end

            if IsPedInAnyVehicle(PlayerPedId(), false) then
                NoClipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
            else
                NoClipEntity = PlayerPedId()
            end

            local yoff = 0.0
            local zoff = 0.0

            DisableControls()

            if IsDisabledControlJustPressed(1, Config.Controls.camMode) then
                timer = 2000
                FollowCamMode = not FollowCamMode
            end

            if IsDisabledControlJustPressed(1, Config.Controls.changeSpeed) then
                timer = 2000
                if index ~= #Config.Speeds then
                    index = index+1
                    CurrentSpeed = Config.Speeds[index].speed
                else
                    CurrentSpeed = Config.Speeds[1].speed
                    index = 1
                end
            end

			if IsDisabledControlPressed(0, Config.Controls.goForward) then
                if Config.FrozenPosition then
                    yoff = -Config.Offsets.y
                else 
                    yoff = Config.Offsets.y
                end
			end
			
            if IsDisabledControlPressed(0, Config.Controls.goBackward) then
                if Config.FrozenPosition then
                    yoff = Config.Offsets.y
                else
                    yoff = -Config.Offsets.y
                end
			end

            if not FollowCamMode and IsDisabledControlPressed(0, Config.Controls.turnLeft) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())+Config.Offsets.h)
			end
			
            if not FollowCamMode and IsDisabledControlPressed(0, Config.Controls.turnRight) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-Config.Offsets.h)
			end
			
            if IsDisabledControlPressed(0, Config.Controls.goUp) then
                zoff = Config.Offsets.z
			end
			
            if IsDisabledControlPressed(0, Config.Controls.goDown) then
                zoff = -Config.Offsets.z
			end
			
            local newPos = GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, yoff * (CurrentSpeed + 0.3), zoff * (CurrentSpeed + 0.3))
            local heading = GetEntityHeading(NoClipEntity)
            SetEntityVelocity(NoClipEntity, 0.0, 0.0, 0.0)
            if Config.FrozenPosition then
                SetEntityRotation(NoClipEntity, 0.0, 0.0, 180.0, 0, false)
            else 
                SetEntityRotation(NoClipEntity, 0.0, 0.0, 0.0, 0, false)
            end
            if(FollowCamMode) then
                SetEntityHeading(NoClipEntity, GetGameplayCamRelativeHeading());
            else
                SetEntityHeading(NoClipEntity, heading);
            end
            if Config.FrozenPosition then
                SetEntityCoordsNoOffset(NoClipEntity, newPos.x, newPos.y, newPos.z, not NoClipActive, not NoClipActive, not NoClipActive)
            else 
                SetEntityCoordsNoOffset(NoClipEntity, newPos.x, newPos.y, newPos.z, NoClipActive, NoClipActive, NoClipActive)
            end

            SetEntityAlpha(NoClipEntity, 51, 0)
            if(NoClipEntity ~= PlayerPedId()) then
                SetEntityAlpha(PlayerPedId(), 51, 0)
            end
            
            SetEntityCollision(NoClipEntity, false, false)
            FreezeEntityPosition(NoClipEntity, true)
            SetEntityInvincible(NoClipEntity, true)
            SetEntityVisible(NoClipEntity, false, false);

            SetEveryoneIgnorePlayer(PlayerPedId(), true);
            SetPoliceIgnorePlayer(PlayerPedId(), true);
            
            SetLocalPlayerVisibleLocally(true);
        
            Citizen.Wait(0)
            
            ResetEntityAlpha(NoClipEntity)
            if(NoClipEntity ~= PlayerPedId()) then
                ResetEntityAlpha(PlayerPedId())
            end

            SetEntityCollision(NoClipEntity, true, true)
            FreezeEntityPosition(NoClipEntity, false)
            SetEntityInvincible(NoClipEntity, false)
            SetEntityVisible(NoClipEntity, true, false);

            SetEveryoneIgnorePlayer(PlayerPedId(), false);
            SetPoliceIgnorePlayer(PlayerPedId(), false);
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('admin:toggleNoClip')
AddEventHandler('admin:toggleNoClip', function()
    NoClipActive = not NoClipActive

    if Config.DisableWeapons then
        if(IsPedArmed(GetPlayerPed(-1), 1 | 2 | 4)) then 
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), 1)
        end
    end

    if Config.FrozenPosition then SetEntityHeading(NoClipEntity, GetEntityHeading(NoClipEntity)+180) end      
end)

function DisableControls()
    DisableControlAction(0, 20, true)
    DisableControlAction(0, 21, true)
    DisableControlAction(0, 30, true)
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 36, true)
    if Config.DisableWeapons then DisableControlAction(0, 37, true) end
    DisableControlAction(0, 38, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 73, true)
    DisableControlAction(0, 74, true)
    DisableControlAction(0, 85, true)
    DisableControlAction(0, 266, true)
    DisableControlAction(0, 267, true)
    DisableControlAction(0, 268, true)
    DisableControlAction(0, 269, true)
end

function RenderScale(scaleform, index, cam)
    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()
    
    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(6)
    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, Config.Controls.openKey, true))
    PushScaleformMovieMethodParameterString(_U("noclip_toggle"))
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(5)
    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, Config.Controls.camMode, true))
    PushScaleformMovieMethodParameterString(_U("noclip_camera"))
    EndScaleformMovieMethod()

    if not cam then
        BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(4)
        PushScaleformMovieMethodParameterString(GetControlInstructionalButton(1, Config.Controls.turnRight, true))
        PushScaleformMovieMethodParameterString(GetControlInstructionalButton(1, Config.Controls.turnLeft, true))
        PushScaleformMovieMethodParameterString(_U("noclip_leftright"))
        EndScaleformMovieMethod()
    end

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(3)
    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, Config.Controls.goDown, true))
    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, Config.Controls.goUp, true))
    PushScaleformMovieMethodParameterString(_U("noclip_updown"))
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(2)
    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(1, Config.Controls.goBackward, true))
    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(1, Config.Controls.goForward, true))
    PushScaleformMovieMethodParameterString(_U("noclip_forbackwards"))
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    PushScaleformMovieMethodParameterString(GetControlInstructionalButton(2, Config.Controls.changeSpeed, true))
    PushScaleformMovieMethodParameterString(_U("noclip_speed", Config.Speeds[index].label))
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    DrawScaleformMovieFullscreen(scaleform) 
end