
Script.Load("lua/DigestMixin.lua")

class 'GorgeTunnelEntrance' (TunnelEntrance)

GorgeTunnelEntrance.kMapName = "gorgetunnelentrance"

local kDigestDuration = 1.5
--local kTunnelInfestationRadius = 7


local networkVars =
{
    ownerId = "entityid",
    variant = "enum kGorgeVariant"
}


function GorgeTunnelEntrance:OnCreate()
    TunnelEntrance.OnCreate(self)
    InitMixin(self, DigestMixin)
    self.variant = kGorgeVariant.normal
end

function GorgeTunnelEntrance:OnInitialized()
    self:SetModel(GorgeTunnelEntrance.kModelName, kAnimationGraph)
    TunnelEntrance.OnInitialized(self)
    
end

function GorgeTunnelEntrance:SetVariant(tunnelVariant)
    TunnelEntrance.SetVariant(self, tunnelVariant)
    self.variant = tunnelVariant
end

if not Server then
    function GorgeTunnelEntrance:GetOwner()
        return self.ownerId ~= nil and Shared.GetEntity(self.ownerId)
    end
end

function GorgeTunnelEntrance:GetOwnerClientId()
    return self.ownerClientId
end

function GorgeTunnelEntrance:GetGorgeOwner()
    return self.ownerId and self.ownerId ~= Entity.invalidId
end

function GorgeTunnelEntrance:GetDigestDuration()
    return kDigestDuration
end

function GorgeTunnelEntrance:GetCanDigest(player)
    return player == self:GetOwner() and player:isa("Gorge") and (not HasMixin(self, "Live") or self:GetIsAlive()) --and self:GetIsBuilt()
end

function GorgeTunnelEntrance:SetOwner(owner)

    if owner and not self.ownerClientId then
    
        local client = Server.GetOwner(owner)
        self.ownerClientId = client:GetUserId()

        if Server then
            self:UpdateConnectedTunnel()
        end
    
        if self.tunnelId and self.tunnelId ~= Entity.invalidId then
        
            local tunnelEnt = Shared.GetEntity(self.tunnelId)
            tunnelEnt:SetOwnerClientId(self.ownerClientId)
        
        end

    end
    
end

function GorgeTunnelEntrance:GetCanBuildOtherEnd()
    return not self:GetGorgeOwner() and TunnelEntrance.GetCanBuildOtherEnd(self)
end

function GorgeTunnelEntrance:GetCanTriggerCollapse()
    return not self:GetGorgeOwner() and TunnelEntrance.GetCanTriggerCollapse(self)
end

function GorgeTunnelEntrance:GetCanRelocate()
    return not self:GetGorgeOwner() and TunnelEntrance.GetCanRelocate(self)
end

if Server then
    
    function GorgeTunnelEntrance:GetTunnelEntity()
        
        if self.tunnelId and self.tunnelId ~= Entity.invalidId then
            return Shared.GetEntity(self.tunnelId)
        end
    
    end
    
    function GorgeTunnelEntrance:UpdateConnectedTunnel()
        local hasValidTunnel = self.tunnelId ~= nil and Shared.GetEntity(self.tunnelId) ~= nil
    
       
        if hasValidTunnel or self:GetOwnerClientId() == nil or not self:GetIsBuilt() then
            return
        end
        
        local foundTunnel
        
        -- register if a tunnel entity already exists or a free tunnel has been found
        for _, tunnel in ientitylist( Shared.GetEntitiesWithClassname("Tunnel") ) do
            if tunnel:GetOwnerClientId() == self:GetOwnerClientId() then
                foundTunnel = tunnel
                break
            end
        end
       -- local newTunnel = false
        if not foundTunnel then
            -- no tunnel entity present
            foundTunnel = CreateEntity(Tunnel.kMapName, nil, self:GetTeamNumber())
            --newTunnel = true
        end
    
        -- check if there is another tunnel entrance to connect with
        foundTunnel:SetOwnerClientId(self:GetOwnerClientId())
    
        local selfId = self:GetId()
        if foundTunnel.exitAId ~= selfId and foundTunnel.exitBId  ~= selfId then
            foundTunnel:AddExit(self)
        end
        self.tunnelId = foundTunnel:GetId()
    
        local foundTunnelEntrance
        -- register if a tunnel entity already exists or a free tunnel has been found
        for _, tunnelEntrance in ientitylist( Shared.GetEntitiesWithClassname("GorgeTunnelEntrance") ) do
            if tunnelEntrance:GetOwnerClientId() == self:GetOwnerClientId() and tunnelEntrance ~= self then
                foundTunnelEntrance = tunnelEntrance
                break
            end
        end
    
        self:SetOtherEntrance(foundTunnelEntrance)
        
        if (foundTunnelEntrance) then
            foundTunnelEntrance:SetOtherEntrance(self)
            local foundTunnelEntranceId = foundTunnelEntrance:GetId()
            if foundTunnel.exitAId ~= foundTunnelEntranceId and foundTunnel.exitBId  ~= foundTunnelEntranceId then
                foundTunnel:AddExit(foundTunnelEntrance)
                foundTunnelEntrance.tunnelId = self.tunnelId
            end
        end
        
    end
    
    function GorgeTunnelEntrance:OnConstructionComplete()
        
            -- Just finished construction, so open animation should play (if it is open).  This is to prevent the open
            -- animation from playing when the tunnel comes into view.
            self.skipOpenAnimation = false
            
            self:UpdateConnectedTunnel()
            self:UpgradeToTechId(kTechId.InfestedTunnel)
            self:SetDesiredInfestationRadius(self:GetInfestationMaxRadius())
       
    end
   
    function GorgeTunnelEntrance:OnKill(attacker, doer, point, direction)
        TunnelEntrance.OnKill(self, attacker, doer, point, direction)

        
            local player = self:GetOwner()
            if player then
                if (self.consumed) then
                    player:AddResources(kGorgeTunnelCostDigest)
                else
                    player:AddResources(kGorgeTunnelCostKill)
                end
        
            end
    end

end

function GorgeTunnelEntrance:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = useSuccessTable.useSuccess and self:GetCanDigest(player)
end

function GorgeTunnelEntrance:GetCanBeUsedConstructed()
    return true
end

function GorgeTunnelEntrance:OnUpdateRender()

    local showDecal = self:GetIsVisible() and not self:GetIsCloaked() and self:GetIsAlive()

    if not self.decal and showDecal then
        self.decal = CreateSimpleInfestationDecal(1.9, self:GetCoords())
    elseif self.decal and not showDecal then
        Client.DestroyRenderDecal(self.decal)
        self.decal = nil
    end

   -- if self._renderModel then
   --     if self.variant == kGorgeVariant.toxin then
   --         self._renderModel:SetMaterialParameter("textureIndex", 1 )
   --     else
   --        self._renderModel:SetMaterialParameter("textureIndex", 0 )
   --     end
   -- end

end


function GorgeTunnelEntrance:GetUnitNameOverride(viewer)

    local unitName = GetDisplayName(self)    
    
    if not GetAreEnemies(self, viewer) and self.ownerId then
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
                return string.format( Locale.ResolveString( "TUNNEL_ENTRANCE_OWNER_ENDS_WITH_S" ), ownerName )
            else
                return string.format( Locale.ResolveString( "TUNNEL_ENTRANCE_OWNER" ), ownerName )
            end
        end
        
    end

    return unitName

end

Shared.LinkClassToMap("GorgeTunnelEntrance", GorgeTunnelEntrance.kMapName, networkVars)