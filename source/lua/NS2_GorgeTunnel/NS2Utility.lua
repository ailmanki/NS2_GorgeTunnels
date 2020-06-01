
-- Look up texture coordinates in kInventoryIconsTexture
-- Used for death messages, inventory icons, and abilities drawn in the alien "energy ball"
local oldGetTexCoordsForTechId = GetTexCoordsForTechId
function GetTexCoordsForTechId(techId)
	
	-- run old function to initialize gTechIdPosition
	oldGetTexCoordsForTechId(techId)
	
	-- add gorgetunnel
	gTechIdPosition[kTechId.GorgeTunnelTech] = kDeathMessageIcon.GorgeTunnel
	
	-- restore original function
	GetTexCoordsForTechId = oldGetTexCoordsForTechId
	
	return oldGetTexCoordsForTechId(techId)
end