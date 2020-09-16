--[[
	PlayingTeam:OnResearchComplete uses a local function GetIsResearchRelevant which returns information based on techId
	using another local table it builds up.
	newGetIsResearchRelevant extends it for GorgeTunnelTech
]]
do
	-- get local function reference
	local oldGetIsResearchRelevant, _, upIndex = debug.getupvaluex(PlayingTeam.OnResearchComplete, "GetIsResearchRelevant", true)
	
	local newGetIsResearchRelevant = function(techId)
		if techId == kTechId.GorgeTunnelTech then
			return 1
		end
		
		return oldGetIsResearchRelevant(techId)
	end
	
	-- replace local function "GetIsResearchRelevant" at in up index "upIndex" with newGetIsResearchRelevant
	debug.setupvalue(PlayingTeam.OnResearchComplete, upIndex, newGetIsResearchRelevant)
end