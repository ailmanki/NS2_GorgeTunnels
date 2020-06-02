-- ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\Shade.lua
--
--    Created by:   Charlie Cleveland (charlie@unknownworlds.com)
--
-- Alien structure that provides cloaking abilities and confuse and deceive capabilities.
--
-- Disorient (Passive) - Enemy structures and players flicker in and out when in range of Shade,
-- making it hard for Commander and team-mates to be able to support each other. Extreme reverb
-- sounds for enemies (and slight reverb sounds for friendlies) enhance the effect.
--
-- Cloak (Triggered) - Instantly cloaks self and all enemy structures and aliens in range
-- for a short time. Mutes or changes sounds too? Cleverly used, this would ideally allow a
-- team to get a stealth hive built. Allow players to stay cloaked for awhile, until they attack
-- (even if they move out of range - great for getting by sentries).
--
-- Hallucination - Allow Commander to create fake Fade, Onos, Hive (and possibly
-- ammo/medpacks). They can be pathed around and used to create tactical distractions or divert
-- forces elsewhere.
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
Script.Load("lua/ScriptActor.lua")
Script.Load("lua/RagdollMixin.lua")
Script.Load("lua/CommAbilities/Alien/ShadeInk.lua")
Script.Load("lua/FireMixin.lua")
Script.Load("lua/ObstacleMixin.lua")
Script.Load("lua/CatalystMixin.lua")
Script.Load("lua/TeleportMixin.lua")
Script.Load("lua/UnitStatusMixin.lua")
Script.Load("lua/UmbraMixin.lua")
Script.Load("lua/DissolveMixin.lua")
Script.Load("lua/MaturityMixin.lua")
Script.Load("lua/MapBlipMixin.lua")
Script.Load("lua/HiveVisionMixin.lua")
Script.Load("lua/TriggerMixin.lua")
Script.Load("lua/CombatMixin.lua")
Script.Load("lua/CommanderGlowMixin.lua")

Script.Load("lua/PathingMixin.lua")
Script.Load("lua/RepositioningMixin.lua")
Script.Load("lua/SupplyUserMixin.lua")
Script.Load("lua/BiomassMixin.lua")
Script.Load("lua/OrdersMixin.lua")
Script.Load("lua/IdleMixin.lua")
Script.Load("lua/ConsumeMixin.lua")

Script.Load("lua/DigestMixin.lua")

local kDigestDuration = 1.5

class 'Shade' (ScriptActor)

Shade.kMapName = "shade"

Shade.kModelName = PrecacheAsset("models/alien/shade/shade.model")
Shade.kAnimationGraph = PrecacheAsset("models/alien/shade/shade.animation_graph")

local kCloakTriggered = PrecacheAsset("sound/NS2.fev/alien/structures/shade/cloak_triggered")
local kCloakTriggered2D = PrecacheAsset("sound/NS2.fev/alien/structures/shade/cloak_triggered_2D")

Shade.kCloakRadius = 17

Shade.kCloakUpdateRate = 0.2

Shade.kMoveSpeed = 2.5

local networkVars = {
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

function Shade:OnCreate()

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
    InitMixin(self, FireMixin)
    InitMixin(self, ObstacleMixin)
    InitMixin(self, CatalystMixin)
    InitMixin(self, TeleportMixin)
    InitMixin(self, UmbraMixin)
    InitMixin(self, DissolveMixin)
    InitMixin(self, MaturityMixin)
    InitMixin(self, CombatMixin)
    InitMixin(self, PathingMixin)
    InitMixin(self, BiomassMixin)
    InitMixin(self, ConsumeMixin)
    InitMixin(self, OrdersMixin, { kMoveOrderCompleteDistance = kAIMoveOrderCompleteDistance })
    InitMixin(self, DigestMixin)
    
    if Server then
    
        --InitMixin(self, TriggerMixin, {kPhysicsGroup = PhysicsGroup.TriggerGroup, kFilterMask = PhysicsMask.AllButTriggers} )
        InitMixin(self, InfestationTrackerMixin)
    elseif Client then
        InitMixin(self, CommanderGlowMixin)            
    end
    
    self:SetLagCompensated(false)
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(PhysicsGroup.MediumStructuresGroup)
    
    self.gorge = false
end

function Shade:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    self:SetModel(Shade.kModelName, Shade.kAnimationGraph)
    
    if Server then
    
        InitMixin(self, StaticTargetMixin)
        InitMixin(self, RepositioningMixin)
        InitMixin(self, SupplyUserMixin)

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

function Shade:GetBioMassLevel()
    return kShadeBiomass
end

function Shade:GetMaturityRate()
    return kShadeMaturationTime
end

function Shade:OverrideRepositioningSpeed()
    return kAlienStructureMoveSpeed * 2.5
end

function Shade:PreventTurning()
    return true
end

function Shade:GetMatureMaxHealth()
    return kMatureShadeHealth
end 

function Shade:GetMatureMaxArmor()
    return kMatureShadeArmor
end   

function Shade:GetDamagedAlertId()
    return kTechId.AlienAlertStructureUnderAttack
end

function Shade:GetCanDie(byDeathTrigger)
    return not byDeathTrigger
end

function Shade:OnDestroy()
    AlienStructure.OnDestroy(self)
    if Server then
        if self.gorge then
            local player = self:GetOwner()
            if player then
                if (self.consumed) then
                    player:AddResources(kGorgeShadeCostDigest)
                else
                    player:AddResources(kGorgeShadeCostKill)
                end
            end
        end
    end
end

function Shade:GetTechButtons(techId)
    local techButtons
    if self:GetGorgeOwner() then
        techButtons = { kTechId.ShadeInk, kTechId.None, kTechId.ShadeCloak, kTechId.None,
                        kTechId.None, kTechId.None, kTechId.None, kTechId.None }
    else
        techButtons = { kTechId.ShadeInk, kTechId.Move, kTechId.ShadeCloak, kTechId.None,
                        kTechId.None, kTechId.None, kTechId.None, kTechId.Consume }
    end
                          
    if self.moving then
        techButtons[2] = kTechId.Stop
    end

    return techButtons
    
end

function Shade:OnConsumeTriggered()
    local currentOrder = self:GetCurrentOrder()
    if currentOrder ~= nil then
        self:CompletedCurrentOrder()
        self:ClearOrders()
    end
end

function Shade:OnOrderGiven(order)
end

function Shade:PerformAction(techNode)

    if techNode:GetTechId() == kTechId.Stop then
        self:ClearOrders()
    end

end

function Shade:OnResearchComplete(researchId)

    -- Transform into mature shade
    if researchId == kTechId.EvolveHallucinations then
        success = self:GiveUpgrade(kTechId.ShadePhantomMenu)
    end
    
end

function Shade:TriggerInk()

    -- Create ShadeInk entity in world at this position with a small offset
    CreateEntity(ShadeInk.kMapName, self:GetOrigin() + Vector(0, 0.2, 0), self:GetTeamNumber())
    self:TriggerEffects("shade_ink")
    return true

end

function Shade:PerformActivation(techId, position, normal, commander)

    local success = false
    
    if techId == kTechId.ShadeInk then
        success = self:TriggerInk()
    end
    
    return success, true
    
end

function Shade:GetReceivesStructuralDamage()
    return true
end

function Shade:OnUpdateAnimationInput(modelMixin)

    PROFILE("Shade:OnUpdateAnimationInput")
    modelMixin:SetAnimationInput("cloak", true)
    modelMixin:SetAnimationInput("moving", self.moving)
    
end

function Shade:GetMaxSpeed()
    return kAlienStructureMoveSpeed
end

function Shade:OnTeleportEnd()
    self:ResetPathing()
end

if Server then

    function Shade:OnConstructionComplete()
        self:AddTimedCallback(Shade.UpdateCloaking, Shade.kCloakUpdateRate)    
    end
    
    function Shade:UpdateCloaking()
    
        if not self:GetIsOnFire() then
            for _, cloakable in ipairs( GetEntitiesWithMixinForTeamWithinRange("Cloakable", self:GetTeamNumber(), self:GetOrigin(), Shade.kCloakRadius) ) do
                cloakable:TriggerCloak()
            end
        end
        
        return self:GetIsAlive()
    
    end

end


function Shade:OnOrderChanged()
    --This will cancel Consume if it is running.
    if self:GetIsConsuming() then
        self:CancelResearch()
    end

    local currentOrder = self:GetCurrentOrder()
    if GetIsUnitActive(self) and currentOrder and currentOrder:GetType() == kTechId.Move then
        self:SetUpdateRate(kRealTimeUpdateRate)
    end
end

function Shade:OnOrderComplete()
    self:SetUpdateRate(kDefaultUpdateRate)
end

function Shade:OnUpdate(deltaTime)

    ScriptActor.OnUpdate(self, deltaTime)        
    UpdateAlienStructureMove(self, deltaTime)

end

function Shade:GetTechAllowed(techId, techNode, player)

    local allowed, canAfford = ScriptActor.GetTechAllowed(self, techId, techNode, player)
    allowed = allowed and not self:GetIsOnFire()
    
    return allowed, canAfford
    
end


if not Server then
    function Shade:GetOwner()
        return self.ownerId ~= nil and Shared.GetEntity(self.ownerId)
    end
end

function Shade:GetGorgeOwner()
    return self.gorge
end
function Shade:GetDigestDuration()
    return kDigestDuration
end

function Shade:GetCanDigest(player)
    return self.gorge and player == self:GetOwner() and player:isa("Gorge") and (not HasMixin(self, "Live") or self:GetIsAlive()) --and self:GetIsBuilt()
end

-- CQ: Predates Mixins, somewhat hackish
function Shade:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = useSuccessTable.useSuccess and self:GetCanDigest(player)
end

function Shade:GetCanBeUsedConstructed()
    return self.gorge
end

function Shade:GetCanTeleportOverride()
    return not self.gorge
end

function Shade:GetCanConsumeOverride()
    return not self.gorge
end


function Shade:GetCanReposition()
    if self.gorge then
        return false
    else
        return true
    end
end


function Shade:OnOverrideOrder(order)
    Print("OnOverrideOrder %s", self.gorge)
    
    if self.gorge then
        order:SetType(kTechId.Default)
    elseif order:GetType() == kTechId.Default then
        order:SetType(kTechId.Move)
    end
end

function Shade:EnableGorgeOwner()
    self.gorge = true
end

function Shade:GetUnitNameOverride(viewer)
    
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
                return string.format( "%s' Shade", ownerName )
            else
                return string.format( "%s's Shade", ownerName )
            end
        end
    
    end
    
    return unitName

end

Shared.LinkClassToMap("Shade", Shade.kMapName, networkVars)