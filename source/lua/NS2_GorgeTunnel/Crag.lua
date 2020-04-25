-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\Crag.lua
--
--    Created by:   Charlie Cleveland (charlie@unknownworlds.com)
--
-- Alien structure that gives the commander defense and protection abilities.
--
-- Passive ability - heals nearby players and structures
-- Triggered ability - emit defensive umbra (8 seconds)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Mixins/ClientModelMixin.lua")
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
Script.Load("lua/CommanderGlowMixin.lua")

Script.Load("lua/ScriptActor.lua")
Script.Load("lua/RagdollMixin.lua")
Script.Load("lua/FireMixin.lua")
Script.Load("lua/SleeperMixin.lua")
Script.Load("lua/ObstacleMixin.lua")
Script.Load("lua/CatalystMixin.lua")
Script.Load("lua/TeleportMixin.lua")
Script.Load("lua/TargetCacheMixin.lua")
Script.Load("lua/UnitStatusMixin.lua")
Script.Load("lua/UmbraMixin.lua")
Script.Load("lua/DissolveMixin.lua")
Script.Load("lua/MaturityMixin.lua")
Script.Load("lua/MapBlipMixin.lua")
Script.Load("lua/HiveVisionMixin.lua")
Script.Load("lua/CombatMixin.lua")

Script.Load("lua/PathingMixin.lua")
Script.Load("lua/RepositioningMixin.lua")
Script.Load("lua/SupplyUserMixin.lua")
Script.Load("lua/BiomassMixin.lua")
Script.Load("lua/OrdersMixin.lua")
Script.Load("lua/IdleMixin.lua")
Script.Load("lua/ConsumeMixin.lua")

Script.Load("lua/DigestMixin.lua")

local kDigestDuration = 1.5

class 'Crag' (ScriptActor)

Crag.kMapName = "crag"

Crag.kModelName = PrecacheAsset("models/alien/crag/crag.model")

Crag.kAnimationGraph = PrecacheAsset("models/alien/crag/crag.animation_graph")

-- Same as NS1
Crag.kHealRadius = 14
Crag.kHealAmount = 10
Crag.kHealWaveAmount = 50
Crag.kMaxTargets = 3
Crag.kThinkInterval = .25
Crag.kHealInterval = 2
Crag.kHealEffectInterval = 1

Crag.kHealWaveDuration = 8

Crag.kHealPercentage = 0.042
Crag.kMinHeal = 7
Crag.kMaxHeal = 42
Crag.kHealWaveMultiplier = 1.3

Crag.kMaxSpeed = 2.5

local networkVars =
{
    -- For client animations
    healingActive = "boolean",
    healWaveActive = "boolean",
    gorge = "boolean",
    moving = "boolean",
    ownerId = "entityid"
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ClientModelMixin, networkVars)
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
AddMixinNetworkVars(DissolveMixin, networkVars)
AddMixinNetworkVars(FireMixin, networkVars)
AddMixinNetworkVars(MaturityMixin, networkVars)
AddMixinNetworkVars(CombatMixin, networkVars)
AddMixinNetworkVars(SelectableMixin, networkVars)
AddMixinNetworkVars(OrdersMixin, networkVars)
AddMixinNetworkVars(IdleMixin, networkVars)
AddMixinNetworkVars(ConsumeMixin, networkVars)

function Crag:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ClientModelMixin)
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
    InitMixin(self, ObstacleMixin)
    InitMixin(self, CatalystMixin)
    InitMixin(self, TeleportMixin)    
    InitMixin(self, UmbraMixin)
    InitMixin(self, DissolveMixin)
    InitMixin(self, MaturityMixin)
    InitMixin(self, CombatMixin)
    InitMixin(self, PathingMixin)
    InitMixin(self, BiomassMixin)
    InitMixin(self, OrdersMixin, { kMoveOrderCompleteDistance = kAIMoveOrderCompleteDistance })
    InitMixin(self, ConsumeMixin)
    InitMixin(self, DigestMixin)
    
    self.healingActive = false
    self.healWaveActive = false
    self.gorge = false
    self:SetUpdates(true, Crag.kThinkInterval)
    
    InitMixin(self, FireMixin)
    
    if Server then
        InitMixin(self, InfestationTrackerMixin)
    elseif Client then    
        InitMixin(self, CommanderGlowMixin)    
    end
    
    self:SetLagCompensated(false)
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(PhysicsGroup.MediumStructuresGroup)
    
end


function Crag:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    self:SetModel(Crag.kModelName, Crag.kAnimationGraph)
    
    if Server then
    
        InitMixin(self, StaticTargetMixin)
        InitMixin(self, SleeperMixin)
        InitMixin(self, RepositioningMixin)
        InitMixin(self, SupplyUserMixin)
        
        -- TODO: USE TRIGGERS, see shade

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

function Crag:PreventTurning()
    return true
end

function Crag:GetBioMassLevel()
    return kCragBiomass
end

function Crag:OnDestroy()
    AlienStructure.OnDestroy(self)
    if Server then
        if self.gorge and self.consumed then
            player = self:GetOwner()
            if player then
                player:AddResources(kGorgeCragCostDigest)
            end
        end
    end
end
function Crag:OverrideRepositioningSpeed()
    return kAlienStructureMoveSpeed * 2.5
end

function Crag:GetMaturityRate()
    return kCragMaturationTime
end

function Crag:GetMatureMaxHealth()
    return kMatureCragHealth
end

function Crag:GetMatureMaxArmor()
    return kMatureCragArmor
end    

function Crag:GetDamagedAlertId()
    return kTechId.AlienAlertStructureUnderAttack
end

function Crag:GetCanSleep()
    return not self.healingActive
end

function Crag:GetHealTargets()

    local targets = {}

    for _, healable in ipairs(GetEntitiesWithMixinForTeamWithinRange("Live", self:GetTeamNumber(), self:GetOrigin(), Crag.kHealRadius)) do

        if healable:GetIsAlive() then
            table.insert(targets, healable)
        end

    end

    return targets

end

function Crag:PerformHealing()

    PROFILE("Crag:PerformHealing")

    local targets = self:GetHealTargets()

    for _, target in ipairs(targets) do

        self:TryHeal(target)

    end

    if #targets > 0 then
        self.timeOfLastHeal = Shared.GetTime()
    end

end

function Crag:TryHeal(target)

    local unclampedHeal = target:GetMaxHealth() * Crag.kHealPercentage
    local heal = Clamp(unclampedHeal, Crag.kMinHeal, Crag.kMaxHeal)
    
    if self.healWaveActive then
        heal = heal * Crag.kHealWaveMultiplier
    end
    
    if target:GetHealthScalar() ~= 1 and (not target.timeLastCragHeal or target.timeLastCragHeal + Crag.kHealInterval <= Shared.GetTime()) then
    
        local amountHealed = target:AddHealth(heal)
        target.timeLastCragHeal = Shared.GetTime()
        return amountHealed
        
    else
        return 0
    end
    
end

function Crag:UpdateHealing()

    local time = Shared.GetTime()
    
    if not self:GetIsOnFire() and ( self.timeOfLastHeal == nil or (time > self.timeOfLastHeal + Crag.kHealInterval) ) then    
        self:PerformHealing()        
    end
    
end

function Crag:OnConsumeTriggered()
    local currentOrder = self:GetCurrentOrder()
    if currentOrder ~= nil then
        self:CompletedCurrentOrder()
        self:ClearOrders()
    end
end

function Crag:GetMaxSpeed()
    return Crag.kMaxSpeed
end

function Crag:OnOrderChanged()
    if self:GetIsConsuming() then
        self:CancelResearch()
    end

    local currentOrder = self:GetCurrentOrder()
    if GetIsUnitActive(self) and currentOrder and currentOrder:GetType() == kTechId.Move then
        self:SetUpdateRate(kRealTimeUpdateRate)
    end
end

function Crag:OnOrderComplete()
    self:SetUpdateRate(Crag.kThinkInterval)
end

-- Look for nearby friendlies to heal
function Crag:OnUpdate(deltaTime)
    
    PROFILE("Crag:OnUpdate")

    ScriptActor.OnUpdate(self, deltaTime)
    
    UpdateAlienStructureMove(self, deltaTime)
    
    if Server then
        
        if GetIsUnitActive(self) then
            self:UpdateHealing()
        end

        self.healingActive = self:GetIsHealingActive()
        self.healWaveActive = self:GetIsHealWaveActive()

    elseif Client then

        if self.healWaveActive or self.healingActive then
        
            if not self.lastHealEffect or self.lastHealEffect + Crag.kHealEffectInterval < Shared.GetTime() then
            
                local localPlayer = Client.GetLocalPlayer()
                local showHeal = not HasMixin(self, "Cloakable") or not self:GetIsCloaked() or not GetAreEnemies(self, localPlayer)
        
                if showHeal then
                
                    if self.healWaveActive then
                        self:TriggerEffects("crag_heal_wave")
                    elseif self.healingActive then
                        self:TriggerEffects("crag_heal")
                    end
                    
                end
                
                self.lastHealEffect = Shared.GetTime()
            
            end
            
        end
    
    end
    
end

function Crag:GetTechButtons(techId)
    local techButtons
    if self:GetGorgeOwner() then
        techButtons = { kTechId.HealWave, kTechId.None, kTechId.CragHeal, kTechId.None,
                              kTechId.None, kTechId.None, kTechId.None, kTechId.None }
    else
        techButtons = { kTechId.HealWave, kTechId.Move, kTechId.CragHeal, kTechId.None,
                              kTechId.None, kTechId.None, kTechId.None, kTechId.Consume }
    end
    
    if self.moving then
        techButtons[2] = kTechId.Stop
    end
    
    return techButtons
    
end

function Crag:PerformAction(techNode)

    if techNode:GetTechId() == kTechId.Stop then
        self:ClearOrders()
    end

end

function Crag:OnTeleportEnd()
    self:ResetPathing()
end

function Crag:GetIsHealWaveActive()
    return self:GetIsAlive() and self:GetIsBuilt() and (self.timeOfLastHealWave ~= nil) and (Shared.GetTime() < (self.timeOfLastHealWave + Crag.kHealWaveDuration))
end

function Crag:GetIsHealingActive()
    return self:GetIsAlive() and self:GetIsBuilt() and (self.timeOfLastHeal ~= nil) and (Shared.GetTime() < (self.timeOfLastHeal + Crag.kHealInterval))
end

function Crag:GetCanHeal()
    return self:GetIsAlive() and self:GetIsBuilt() and not self:GetIsOnFire()
end

function Crag:TriggerHealWave(commander)

    self.timeOfLastHealWave = Shared.GetTime()
    return true
    
end

function Crag:GetReceivesStructuralDamage()
    return true
end

function Crag:GetTechAllowed(techId, techNode, player)

    local allowed, canAfford = ScriptActor.GetTechAllowed(self, techId, techNode, player)
    allowed = allowed and not self:GetIsOnFire()
    
    return allowed, canAfford

end

function Crag:PerformActivation(techId, position, normal, commander)

    local success = false
    
    if techId == kTechId.HealWave then
        success = self:TriggerHealWave(commander)
    end
    
    return success, true
    
end

function Crag:OnUpdateAnimationInput(modelMixin)

    PROFILE("Crag:OnUpdateAnimationInput")
    modelMixin:SetAnimationInput("heal", self.healingActive or self.healWaveActive)
    modelMixin:SetAnimationInput("moving", self.moving)
    
end


if not Server then
    function Crag:GetOwner()
        return self.ownerId ~= nil and Shared.GetEntity(self.ownerId)
    end
end

function Crag:GetGorgeOwner()
    return self.gorge
end
function Crag:GetDigestDuration()
    return kDigestDuration
end

function Crag:GetCanDigest(player)
    return self.gorge and player == self:GetOwner() and player:isa("Gorge") and (not HasMixin(self, "Live") or self:GetIsAlive()) --and self:GetIsBuilt()
end

-- CQ: Predates Mixins, somewhat hackish
function Crag:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = useSuccessTable.useSuccess and self:GetCanDigest(player)
end

function Crag:GetCanBeUsedConstructed()
    return self.gorge
end

function Crag:GetCanTeleportOverride()
    return not self.gorge
end

function Crag:GetCanConsumeOverride()
    return not self.gorge
end


function Crag:GetCanReposition()
    if self.gorge then
        return false
    else
        return true
    end
end


function Crag:OnOverrideOrder(order)
    if self.gorge then
        order:SetType(kTechId.Default)
    elseif order:GetType() == kTechId.Default then
        order:SetType(kTechId.Move)
    end
end

function Crag:EnableGorgeOwner()
    self.gorge = true
end

function Crag:GetUnitNameOverride(viewer)
    
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
                return string.format( "%s' Crag", ownerName )
            else
                return string.format( "%s's Crag", ownerName )
            end
        end
    
    end
    
    return unitName

end

Shared.LinkClassToMap("Crag", Crag.kMapName, networkVars)