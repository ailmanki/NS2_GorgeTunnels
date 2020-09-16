-- AppendToEnum Code used from Nin's Hades Device https://steamcommunity.com/sharedfiles/filedetails/?id=873978863

local function AppendToEnum(tbl, key)
	if rawget(tbl, key) ~= nil then
		return
	end
	
	local maxVal = 0
	for _, v in next, tbl do
		if type(v) == "number" and v > maxVal then
			maxVal = v
		end
	end
	
	rawset(tbl, key, maxVal + 1)
	rawset(tbl, maxVal + 1, key)

end


-- incrase max...
kTechIdMax = kTechIdMax + 4

AppendToEnum(kTechId, "GorgeWhip")
AppendToEnum(kTechId, "GorgeCrag")
AppendToEnum(kTechId, "GorgeShift")
AppendToEnum(kTechId, "GorgeShade")

AppendToEnum(kTechId, "DropSentry")
AppendToEnum(kTechId, "BuildSentry")
