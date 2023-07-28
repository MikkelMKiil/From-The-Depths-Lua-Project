AllowedError = 1;
-- Increase this if you are using massive height offsets!
ExplosionHeightOffset = 100;
-- The offset used, 25 here means aim 25 blocks above the target

SelectedMainframe = 0
--Which mainframe you want to use for targeting.
--I:Log(I:GetNumberOfMainframes())
--Uncomment above this to figure out how many mainframes you have, note they start at 0 so 1 mainframe = 0 2 is = 1

SelectedWeapon = 0
--Which weapon you want to use for targeting.
--I:Log(I:I:GetWeaponCount())
--Uncomment above this to figure out how many weapons you have, note they start at 0 so 1 weapon = 0 2 is = 1

-- Main Loop
function Update(I)
    if I:GetTargetInfo(SelectedMainframe, 0).Id > 0 then
        local EnemyInfo = I:GetTargetInfo(SelectedMainframe, 0)
        local WeaponInfo = I:GetWeaponInfo(SelectedWeapon)
        local EnemyRelative = EnemyInfo.Position - WeaponInfo.GlobalFirePoint
        local PredictedPosition = EnemyInfo.Position - WeaponInfo.GlobalFirePoint + (EnemyInfo.Velocity * EnemyInfo.Position.magnitude / WeaponInfo.Speed)
        local BulletDropAirburstOffset = PredictedPosition.y + (0.5 * 9.81 * math.pow(PredictedPosition.magnitude / WeaponInfo.Speed, 2)) + ExplosionHeightOffset
        local SetFuseTime = I:Component_SetFloatLogic(13, SelectedWeapon, PredictedPosition.magnitude / WeaponInfo.Speed)
        I:AimWeaponInDirection(SelectedWeapon, PredictedPosition.x, BulletDropAirburstOffset, PredictedPosition.z, 0)
        local AimError = PredictedPosition.normalized - WeaponInfo.CurrentDirection
        if math.abs(AimError.x) < AllowedError and math.abs(AimError.z) < AllowedError then 
            I:FireWeapon(SelectedWeapon, 0)
        end
    end
end
