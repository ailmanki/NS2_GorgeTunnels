

local kTechIdGorge = {}
kTechIdGorge[kTechId.GorgeCrag] = kTechId.Crag
kTechIdGorge[kTechId.GorgeWhip] = kTechId.Whip
kTechIdGorge[kTechId.GorgeShift] = kTechId.Shift
kTechIdGorge[kTechId.GorgeShade] = kTechId.Shade
kTechIdGorge[kTechId.GorgeTunnel] = kTechId.TeleportTunnel
kTechIdGorge[kTechId.GorgeTunnelTech] = kTechId.TeleportTunnel

-- GetMaterialXYOffset Code used from Nin's Hades Device https://steamcommunity.com/sharedfiles/filedetails/?id=873978863
local origGetMaterialXYOffset = GetMaterialXYOffset
function GetMaterialXYOffset(techId)
	if kTechIdGorge[techId] ~= nil then
		techId = kTechIdGorge[techId]
	end
	return origGetMaterialXYOffset(techId)
end