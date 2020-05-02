-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\Shift.lua
--
--    Created by:   Charlie Cleveland (charlie@unknownworlds.com)
--
-- Alien structure that allows commander to outmaneuver and redeploy forces. 
--
-- Recall - Ability that lets players jump to nearest structure (or hive) under attack (cooldown 
-- of a few seconds)
-- Energize - Passive ability that gives energy to nearby players
-- Echo - Targeted ability that lets Commander move a structure or drifter elsewhere on the map
-- (even a hive or harvester!). 
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/CommAbilities/Alien/ShiftEcho.lua")
Script.Load("lua/Mixins/ModelMixin.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/UpgradableMixin.lua")
Script.Load("lua/PointGiverMixin.lua")
Script.Load("lua/AchievementGiverMixin.lua")
Script.Load("lua/GameEffectsMixin.lua")
Script.Load("lua/SelectableMixin.lua")
Script.Load("lua/FlinchMixin.lua")
Script.Load("lua/CloakableMixin.lua")
Script.Load("lua/LOSMixin.lua")
Script.Load("lua/DetectableMixin.lua")
Script.Load("lua/InfestationTrackerMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/EntityChangeMixin.lua")
Script.Load("lua/ConstructMixin.lua")
Script.Load("lua/ResearchMixin.lua")
Script.Load("lua/ScriptActor.lua")
Script.Load("lua/RagdollMixin.lua")
Script.Load("lua/FireMixin.lua")
Script.Load("lua/ObstacleMixin.lua")
Script.Load("lua/CatalystMixin.lua")
Script.Load("lua/TeleportMixin.lua")
Script.Load("lua/UmbraMixin.lua")
Script.Load("lua/MaturityMixin.lua")
Script.Load("lua/MapBlipMixin.lua")
Script.Load("lua/HiveVisionMixin.lua")
Script.Load("lua/CombatMixin.lua")
Script.Load("lua/CommanderGlowMixin.lua")
Script.Load("lua/DissolveMixin.lua")

Script.Load("lua/PathingMixin.lua")
Script.Load("lua/RepositioningMixin.lua")
Script.Load("lua/SupplyUserMixin.lua")
Script.Load("lua/BiomassMixin.lua")
Script.Load("lua/OrdersMixin.lua")
Script.Load("lua/IdleMixin.lua")
Script.Load("lua/ConsumeMixin.lua")

Script.Load("lua/DigestMixin.lua")

local kDigestDuration = 1.5

class 'Shift' (ScriptActor)

Shift.kMapName = "shift"

Shift.kModelName = PrecacheAsset("models/alien/shift/shift.model")

local kAnimationGraph = PrecacheAsset("models/alien/shift/shift.animation_graph")

Shift.kEchoTargetSound = PrecacheAsset("sound/NS2.fev/alien/structures/shift/energize")
Shift.kShiftEchoSound2D = PrecacheAsset("sound/NS2.fev/alien/structures/shift/energize_player")

Shift.kEnergizeSoundEffect = PrecacheAsset("sound/NS2.fev/alien/structures/shift/energize")
Shift.kEnergizeTargetSoundEffect = PrecacheAsset("sound/NS2.fev/alien/structures/shift/energize_player")
--Shift.kRecallSoundEffect = PrecacheAsset("sound/NS2.fev/alien/structures/shift/recall")


Shift.kEnergizeEffect = PrecacheAsset("cinematics/alien/shift/energize.cinematic")
Shift.kEnergizeSmallTargetEffect = PrecacheAsset("cinematics/alien/shift/energize_small.cinematic")
Shift.kEnergizeLargeTargetEffect = PrecacheAsset("cinematics/alien/shift/energize_large.cinematic")

Shift.kEchoMaxRange = 20

Shift.kMoveSpeed = 2.5

local kNumEggSpotsPerShift = 20

local kEchoCooldown = 1

local networkVars =
{
    hydraInRange = "boolean",
    whipInRange = "boolean",
    tunnelInRange = "boolean",
    cragInRange = "boolean",
    shadeInRange = "boolean",
    shiftInRange = "boolean",
    veilInRange = "boolean",
    spurInRange = "boolean",
    shellInRange = "boolean",
    hiveInRange = "boolean",
    eggInRange = "boolean",
    harvesterInRange = "boolean",
    echoActive = "boolean",

    gorge = "boolean",
    moving = "boolean",
    ownerId = "entityid"
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(UpgradableMixin, networkVars)
AddMixinNetworkVars(GameEffectsMixin, networkVars)
AddMixinNetworkVars(FlinchMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(CloakableMixin, networkVars)
AddMixinNetworkVars(LOSMixin, networkVars)
AddMixinNetworkVars(DetectableMixin, networkVars)
AddMixinNetworkVars(ConstructMixin, networkVars)
AddMixinNetworkVars(ResearchMixin, networkVars)
AddMixinNetworkVars(ObstacleMixin, networkVars)
AddMixinNetworkVars(CatalystMixin, networkVars)
AddMixinNetworkVars(TeleportMixin, networkVars)
AddMixinNetworkVars(UmbraMixin, networkVars)
AddMixinNetworkVars(FireMixin, networkVars)
AddMixinNetworkVars(MaturityMixin, networkVars)
AddMixinNetworkVars(CombatMixin, networkVars)
AddMixinNetworkVars(DissolveMixin, networkVars)
AddMixinNetworkVars(SelectableMixin, networkVars)
AddMixinNetworkVars(OrdersMixin, networkVars)
AddMixinNetworkVars(IdleMixin, networkVars)
AddMixinNetworkVars(ConsumeMixin, networkVars)

local function GetIsTeleport(techId)

return techId == kTechId.TeleportHydra or
       techId == kTechId.TeleportWhip or
       techId == kTechId.TeleportTunnel or
       techId == kTechId.TeleportCrag or
       techId == kTechId.TeleportShade or
       techId == kTechId.TeleportShift or
       techId == kTechId.TeleportVeil or
       techId == kTechId.TeleportSpur or
       techId == kTechId.TeleportShell or
       techId == kTechId.TeleportHive or
       techId == kTechId.TeleportEgg or
       techId == kTechId.TeleportHarvester

end

local gTeleportClassnames
local function GetTeleportClassname(techId)

    if not gTeleportClassnames then
    
        gTeleportClassnames = {}
        gTeleportClassnames[kTechId.TeleportHydra] = "Hydra"
        gTeleportClassnames[kTechId.TeleportWhip] = "Whip"
        gTeleportClassnames[kTechId.TeleportTunnel] = "TunnelEntrance"
        gTeleportClassnames[kTechId.TeleportCrag] = "Crag"
        gTeleportClassnames[kTechId.TeleportShade] = "Shade"
        gTeleportClassnames[kTechId.TeleportShift] = "Shift"
        gTeleportClassnames[kTechId.TeleportVeil] = "Veil"
        gTeleportClassnames[kTechId.TeleportSpur] = "Spur"
        gTeleportClassnames[kTechId.TeleportShell] = "Shell"
        gTeleportClassnames[kTechId.TeleportHive] = "Hive"
        gTeleportClassnames[kTechId.TeleportEgg] = "Egg"
        gTeleportClassnames[kTechId.TeleportHarvester] = "Harvester"
    
    end
    
    return gTeleportClassnames[techId]


end

local function ResetShiftButtons(self)

    self.hydraInRange = false
    self.whipInRange = false
    self.tunnelInRange = false
    self.cragInRange = false
    self.shadeInRange = false
    self.shiftInRange = false
    self.veilInRange = false
    self.spurInRange = false
    self.shellInRange = false
    self.hiveInRange = false
    self.eggInRange = false
    self.harvesterInRange = false
    
end

local function UpdateShiftButtons(self)

    ResetShiftButtons(self)

    local teleportAbles = GetEntitiesWithMixinForTeamWithinXZRange("TeleportAble", self:GetTeamNumber(), self:GetOrigin(), kEchoRange)    
    for _, teleportable in ipairs(teleportAbles) do
    
        if teleportable:GetCanTeleport() then
        
            if teleportable:isa("Hydra") then
                self.hydraInRange = true
            elseif teleportable:isa("Whip") then
                self.whipInRange = true
            elseif teleportable:isa("TunnelEntrance") then
                self.tunnelInRange = true
            elseif teleportable:isa("Crag") then
                self.cragInRange = true
            elseif teleportable:isa("Shade") then
                self.shadeInRange = true
            elseif teleportable:isa("Shift") then
                self.shiftInRange = true
            elseif teleportable:isa("Veil") then
                self.veilInRange = true
            elseif teleportable:isa("Spur") then
                self.spurInRange = true
            elseif teleportable:isa("Shell") then
                self.shellInRange = true
            elseif teleportable:isa("Hive") then
                self.hiveInRange = true
            elseif teleportable:isa("Egg") then
                self.eggInRange = true
            elseif teleportable:isa("Harvester") then
                self.harvesterInRange = true
            end
            
        end
    end

end

function Shift:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, LiveMixin)
    InitMixin(self, UpgradableMixin)
    InitMixin(self, GameEffectsMixin)
    InitMixin(self, FlinchMixin, { kPlayFlinchAnimations = true })
    InitMixin(self, TeamMixin)
    InitMixin(self, PointGiverMixin)
    InitMixin(self, AchievementGiverMixin)
    InitMixin(self, SelectableMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, CloakableMixin)
    InitMixin(self, LOSMixin)
    InitMixin(self, DetectableMixin)
    InitMixin(self, ConstructMixin)
    InitMixin(self, ResearchMixin)
    InitMixin(self, RagdollMixin)
    InitMixin(self, FireMixin)
    InitMixin(self, ObstacleMixin)
    InitMixin(self, CatalystMixin)
    InitMixin(self, TeleportMixin)
    InitMixin(self, UmbraMixin)
    InitMixin(self, MaturityMixin)
    InitMixin(self, CombatMixin)
    InitMixin(self, DissolveMixin)
    InitMixin(self, PathingMixin)
    InitMixin(self, BiomassMixin)
    InitMixin(self, OrdersMixin, { kMoveOrderCompleteDistance = kAIMoveOrderCompleteDistance })
    InitMixin(self, ConsumeMixin)
    InitMixin(self, DigestMixin)
    
    ResetShiftButtons(self)
    
    if Server then
    
        InitMixin(self, InfestationTrackerMixin)
        self.remainingFindEggSpotAttempts = 300
        self.eggSpots = {}
        
    elseif Client then
        InitMixin(self, CommanderGlowMixin)    
    end
    
    self:SetLagCompensated(false)
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(PhysicsGroup.MediumStructuresGroup)
    
    self.gorge = false
    self.echoActive = false
    self.timeLastEcho = 0
    
end

function Shift:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    self:SetModel(Shift.kModelName, kAnimationGraph)
    
    if Server then
    
        InitMixin(self, StaticTargetMixin)
        InitMixin(self, RepositioningMixin)
        InitMixin(self, SupplyUserMixin)
    
        self:AddTimedCallback(Shift.EnergizeInRange, 0.5)
        self.shiftEggs = {}
        
        -- This Mixin must be inited inside this OnInitialized() function.
        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end
        
    elseif Client then
    
        InitMixin(self, UnitStatusMixin)
        InitMixin(self, HiveVisionMixin)
        
    end
    
    InitMixin(self, IdleMixin)

end

function Shift:GetBioMassLevel()
    return kShiftBiomass
end

function Shift:EnergizeInRange()

    if self:GetIsBuilt() and not self:GetIsOnFire() then
    
        local energizeAbles = GetEntitiesWithMixinForTeamWithinXZRange("Energize", self:GetTeamNumber(), self:GetOrigin(), kEnergizeRange)
        
        for _, entity in ipairs(energizeAbles) do
        
            if entity ~= self then
                entity:Energize(self)
            end
            
        end
    
    end
    
    return self:GetIsAlive()
    
end

function Shift:GetDamagedAlertId()
    return kTechId.AlienAlertStructureUnderAttack
end

function Shift:GetReceivesStructuralDamage()
    return true
end

function Shift:GetMaturityRate()
    return kShiftMaturationTime
end

function Shift:GetMatureMaxHealth()
    return kMatureShiftHealth
end 

function Shift:GetMatureMaxArmor()
    return kMatureShiftArmor
end

function Shift:PreventTurning()
    return true
end

function Shift:OverrideRepositioningSpeed()
    return kAlienStructureMoveSpeed * 2.5
end

function Shift:GetTechAllowed(techId, techNode, player)

    local allowed, canAfford = ScriptActor.GetTechAllowed(self, techId, techNode, player) 
    
    allowed = allowed and not self.echoActive and not self:GetIsOnFire()
    
    if allowed then
 
        if techId == kTechId.TeleportHydra then
            allowed = self.hydraInRange
        elseif techId == kTechId.TeleportWhip then
            allowed = self.whipInRange
        elseif techId == kTechId.TeleportTunnel then
            allowed = self.tunnelInRange
        elseif techId == kTechId.TeleportCrag then
            allowed = self.cragInRange
        elseif techId == kTechId.TeleportShade then
            allowed = self.shadeInRange
        elseif techId == kTechId.TeleportShift then
            allowed = self.shiftInRange
        elseif techId == kTechId.TeleportVeil then
            allowed = self.veilInRange
        elseif techId == kTechId.TeleportSpur then
            allowed = self.spurInRange
        elseif techId == kTechId.TeleportShell then
            allowed = self.shellInRange
        elseif techId == kTechId.TeleportHive then
            allowed = self.hiveInRange
        elseif techId == kTechId.TeleportEgg then
            allowed = self.eggInRange
        elseif techId == kTechId.TeleportHarvester then
            allowed = self.harvesterInRange
        end
    
    end
    
    return allowed, canAfford
    
end

function Shift:GetTechButtons(techId)

    local techButtons
                
    if techId == kTechId.ShiftEcho then

        techButtons = { kTechId.TeleportEgg, kTechId.TeleportWhip, kTechId.TeleportHarvester, kTechId.TeleportShift, 
                        kTechId.TeleportCrag, kTechId.TeleportShade, kTechId.None, kTechId.RootMenu }
                        

        if self.veilInRange then
            techButtons[7] = kTechId.TeleportVeil
        elseif self.shellInRange then
            techButtons[7] = kTechId.TeleportShell
        elseif self.spurInRange then
            techButtons[7] = kTechId.TeleportSpur
        end

    else
    
        if self:GetGorgeOwner() then
            techButtons = { kTechId.ShiftEcho, kTechId.None, kTechId.ShiftEnergize, kTechId.None,
                            kTechId.None, kTechId.None, kTechId.None, kTechId.None }
        else
            techButtons = { kTechId.ShiftEcho, kTechId.Move, kTechId.ShiftEnergize, kTechId.None,
                            kTechId.None, kTechId.None, kTechId.None, kTechId.Consume }
        end
    
        if self.moving then
            techButtons[2] = kTechId.Stop
        end

    end

    return techButtons   

end

function Shift:OnUpdateAnimationInput(modelMixin)

    PROFILE("Shift:OnUpdateAnimationInput")
    modelMixin:SetAnimationInput("moving", self.moving)
    modelMixin:SetAnimationInput("echo", self.echoActive)
    
end

function Shift:GetMaxSpeed()
    return Shift.kMoveSpeed
end

function Shift:OnConsumeTriggered()
    local currentOrder = self:GetCurrentOrder()
    if currentOrder ~= nil then
        self:CompletedCurrentOrder()
        self:ClearOrders()
    end
end

function Shift:OnOrderChanged()
    if self:GetIsConsuming() then
        self:CancelResearch()
    end

    local currentOrder = self:GetCurrentOrder()
    if GetIsUnitActive(self) and currentOrder and currentOrder:GetType() == kTechId.Move then
        self:SetUpdateRate(kRealTimeUpdateRate)
    end
end

function Shift:OnOrderComplete()
    self:SetUpdateRate(kDefaultUpdateRate)
end

function Shift:OnUpdate(deltaTime)

    PROFILE("Shift:OnUpdate")

    ScriptActor.OnUpdate(self, deltaTime)
    UpdateAlienStructureMove(self, deltaTime)        

    if Server then

        if not self.timeLastButtonCheck or self.timeLastButtonCheck + 2 < Shared.GetTime() then
        
            self.timeLastButtonCheck = Shared.GetTime()
            UpdateShiftButtons(self)
            
        end
        
        self.echoActive = self.timeLastEcho + kEchoCooldown > Shared.GetTime()
    
    end
        
end

if Server then

    function Shift:OnTeleportEnd()
        self:ResetPathing()
    end

    function Shift:OnResearchComplete(researchId)

        -- Transform into mature shift
        if researchId == kTechId.EvolveEcho then
            self:GiveUpgrade(kTechId.ShiftEcho)
        end
        
    end

    function Shift:TriggerEcho(techId, position)
    
        local teleportClassname = GetTeleportClassname(techId)
        local teleportCost = LookupTechData(techId, kTechDataCostKey, 0)
        
        local success = false
        
        local validPos = GetIsBuildLegal(techId, position, 0, kStructureSnapRadius, self:GetOwner(), self)
        
        local builtStructures = {} 
        local matureStructures = {} 
        
        if validPos then
        
            local teleportAbles = GetEntitiesForTeamWithinXZRange(teleportClassname, self:GetTeamNumber(), self:GetOrigin(), kEchoRange)
            
                for index, entity in ipairs(teleportAbles) do
                    if HasMixin(entity, "Construct") and entity:GetIsBuilt() then
                        table.insert(builtStructures, entity)
                        if HasMixin(entity, "Maturity") and entity:GetIsMature() then
                            table.insert(matureStructures, entity)
                        end
                    end
                end

                if #matureStructures > 0 then
                    teleportAbles = matureStructures
                elseif #builtStructures > 0 then
                    teleportAbles = builtStructures
                end
                
                Shared.SortEntitiesByDistance(self:GetOrigin(), teleportAbles)
                
            for _, teleportAble in ipairs(teleportAbles) do
            
                if teleportAble:GetCanTeleport() then
                
                    teleportAble:TriggerTeleport(5, self:GetId(), position, teleportCost)
                        
                    if HasMixin(teleportAble, "Orders") then
                        teleportAble:ClearCurrentOrder()
                    end
                    
                    self:TriggerEffects("shift_echo")
                    success = true
                    self.echoActive = true
                    self.timeLastEcho = Shared.GetTime()
                    break
                    
                end
            
            end
        
        end
        
        return success
        
    end

    function Shift:GetNumEggs()
        return #self.shiftEggs
    end
    
    function Shift:PerformActivation(techId, position, normal, commander)
    
        local success = false
        local continue = true
        
        if GetIsTeleport(techId) then
        
            success = self:TriggerEcho(techId, position)
            if success then
                UpdateShiftButtons(self)
                Shared.PlayPrivateSound(commander, Shift.kShiftEchoSound2D, nil, 1.0, self:GetOrigin())                
            end
            
        end
        
        return success, continue
        
    end
    
    function Shift:OnEntityChange(oldId, newId)
        
        if table.icontains(self.shiftEggs, oldId) then
            table.removevalue(self.shiftEggs, oldId)
        end
    end
    
    function Shift:OnKill(attacker, doer, point, direction)
        
        ScriptActor.OnKill(self, attacker, doer, point, direction)
        
        local team = self:GetTeam()
        if team then
            team:UpdateClientOwnedStructures(self:GetId())
        end
    
        if self.gorge then
            player = self:GetOwner()
            if player then
                if (self.consumed) then
                    player:AddResources(kGorgeShiftCostDigest)
                else
                    player:AddResources(kGorgeShiftCostKill)
                end
            end
        end
    end
end


function GetShiftIsBuilt(techId, origin, normal, commander)

    -- check if there is a built command station in our team
    if not commander then
        return false
    end    
    
    local attachRange = LookupTechData(kTechId.ShiftHatch, kStructureAttachRange, 1)
    
    local shifts = GetEntitiesForTeamWithinXZRange("Shift", commander:GetTeamNumber(), origin, attachRange)
    for _, shift in ipairs(shifts) do
        
        if shift:GetIsBuilt() then
            return true
        end    
        
    end
    
    return false
    
end

function GetShiftHatchGhostGuides(commander)

    local entities = { }
    local ranges = { }

    local shifts = GetEntitiesForTeam("Shift", commander:GetTeamNumber())
    local attachRange = LookupTechData(kTechId.ShiftHatch, kStructureAttachRange, 1)

    for _, shift in ipairs(shifts) do
        if shift:GetIsBuilt() then
            ranges[shift] = attachRange
            table.insert(entities, shift)
        end
    end

    return entities, ranges

end


if not Server then
    function Shift:GetOwner()
        return self.ownerId ~= nil and Shared.GetEntity(self.ownerId)
    end
end

function Shift:GetGorgeOwner()
    return self.gorge
end
function Shift:GetDigestDuration()
    return kDigestDuration
end

function Shift:GetCanDigest(player)
    return self.gorge and player == self:GetOwner() and player:isa("Gorge") and (not HasMixin(self, "Live") or self:GetIsAlive()) --and self:GetIsBuilt()
end

-- CQ: Predates Mixins, somewhat hackish
function Shift:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = useSuccessTable.useSuccess and self:GetCanDigest(player)
end

function Shift:GetCanBeUsedConstructed()
    return self.gorge
end

function Shift:GetCanTeleportOverride()
    return not self.gorge
end

function Shift:GetCanConsumeOverride()
    return not self.gorge
end


function Shift:GetCanReposition()
    if self.gorge then
        return false
    else
        return true
    end
end


function Shift:OnOverrideOrder(order)
    if self.gorge then
        order:SetType(kTechId.Default)
    elseif order:GetType() == kTechId.Default then
        order:SetType(kTechId.Move)
    end
end

function Shift:EnableGorgeOwner()
    self.gorge = true
end

function Shift:GetUnitNameOverride(viewer)
    
    local unitName = GetDisplayName(self)
    
    if self.gorge and not GetAreEnemies(self, viewer) and self.ownerId then
        local ownerName
        for _, playerInfo in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do
            if playerInfo.playerId == self.ownerId then
                ownerName = playerInfo.playerName
                break
            end
        end
        if ownerName then
            
            local lastLetter = ownerName:sub(-1)
            if lastLetter == "s" or lastLetter == "S" then
                return string.format( "%s' Shift", ownerName )
            else
                return string.format( "%s's Shift", ownerName )
            end
        end
    
    end
    
    return unitName

end

Shared.LinkClassToMap("Shift", Shift.kMapName, networkVars)
