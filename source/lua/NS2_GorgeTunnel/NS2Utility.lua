-- Look up texture coordinates in kInventoryIconsTexture
-- Used for death messages, inventory icons, and abilities drawn in the alien "energy ball"
local oldGetTexCoordsForTechId = GetTexCoordsForTechId
function GetTexCoordsForTechId(techId)
    if not gTechIdPosition then
        oldGetTexCoordsForTechId(techId)
        gTechIdPosition[kTechId.GorgeTunnelTech] = kDeathMessageIcon.GorgeTunnel
    end
    return oldGetTexCoordsForTechId(techId)
end