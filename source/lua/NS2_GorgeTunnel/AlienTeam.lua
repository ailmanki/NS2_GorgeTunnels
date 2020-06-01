
-- InitTechTree Code used from Nin's Hades Device https://steamcommunity.com/sharedfiles/filedetails/?id=873978863
-- this is pretty tricky
local oldInitTechTree = AlienTeam.InitTechTree
function AlienTeam:InitTechTree()
	
	PlayingTeam.InitTechTree(self)
	
	self.techTree:AddBuildNode(kTechId.GorgeTunnel)
	self.techTree:AddBuildNode(kTechId.GorgeWhip)
	self.techTree:AddBuildNode(kTechId.GorgeCrag)
	self.techTree:AddBuildNode(kTechId.GorgeShift)
	self.techTree:AddBuildNode(kTechId.GorgeShade)
	
	-- temporarily disable initializing the tech tree
	local oldPlayingInit = PlayingTeam.InitTechTree
	PlayingTeam.InitTechTree = function() end
	oldInitTechTree(self)
	-- re-enable it now
	PlayingTeam.InitTechTree = oldPlayingInit
end

local function ApplyGorgeStructureTheme(structure, player)
	
	assert(player:isa("Gorge"))
	
	if structure.SetVariant then
		structure:SetVariant(player:GetVariant())
	end

end

local oldAddGorgeStructure = AlienTeam.AddGorgeStructure
function AlienTeam:AddGorgeStructure(player, structure)
	if player ~= nil and structure ~= nil then
		oldAddGorgeStructure(player, structure)
		ApplyGorgeStructureTheme(structure, player)
	end
end
