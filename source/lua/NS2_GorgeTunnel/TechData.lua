local oldBuildTechData = BuildTechData
function BuildTechData()
    local kTechData = oldBuildTechData()
    
    local tech = {}
    for k=1, #kTechData do
        table.insert(tech, kTechData[k])
        if (kTechData[k][kTechDataId] == kTechId.Crag) then
            table.insert(tech, {
                [kTechDataId] = kTechId.GorgeCrag,
                [kTechDataCategory] = kTechId.Gorge,
                [kTechDataAllowConsumeDrop] = false,
                [kTechDataMaxAmount] = 3,
                [kTechDataBioMass] = kCragBiomass,
                [kTechDataSupply] = kCragSupply,
                [kTechDataHint] = "CRAG_HINT",
                [kTechDataGhostModelClass] = "AlienGhostModel",
                [kTechDataMapName] = GorgeCrag.kMapName,
                [kTechDataDisplayName] = "CRAG",
                [kTechDataCostKey] = kGorgeCragCost,
                [kTechDataRequiresInfestation] = true,
                [kTechDataHotkey] = Move.C,
                [kTechDataBuildTime] = kCragBuildTime,
                [kTechDataModel] = Crag.kModelName,
                [kTechDataMaxHealth] = kCragHealth,
                [kTechDataMaxArmor] = kCragArmor,
                [kTechDataInitialEnergy] = kCragInitialEnergy,
                [kTechDataMaxEnergy] = kCragMaxEnergy,
                [kTechDataPointValue] = kCragPointValue,
                [kVisualRange] = Crag.kHealRadius,
                [kTechDataTooltipInfo] = "CRAG_TOOLTIP",
                [kTechDataGrows] = true,
            })
        end
        
        if (kTechData[k][kTechDataId] == kTechId.Whip) then
            table.insert(tech, {
                [kTechDataId] = kTechId.GorgeWhip,
                [kTechDataCategory] = kTechId.Gorge,
                [kTechDataBioMass] = kWhipBiomass,
                [kTechDataSupply] = kWhipSupply,
                [kTechDataAllowConsumeDrop] = false,
                [kTechDataHint] = "WHIP_HINT",
                [kTechDataGhostModelClass] = "AlienGhostModel",
                [kTechDataMapName] = GorgeWhip.kMapName,
                [kTechDataDisplayName] = "WHIP",
                [kTechDataCostKey] = kGorgeWhipCost,
                [kTechDataRequiresInfestation] = true,
                [kTechDataHotkey] = Move.W,
                [kTechDataBuildTime] = kWhipBuildTime,
                [kTechDataModel] = Whip.kModelName,
                [kTechDataMaxHealth] = kWhipHealth,
                [kTechDataMaxArmor] = kWhipArmor,
                [kTechDataDamageType] = kDamageType.Structural,
                [kTechDataInitialEnergy] = kWhipInitialEnergy,
                [kTechDataMaxEnergy] = kWhipMaxEnergy,
                [kVisualRange] = Whip.kRange,
                [kTechDataPointValue] = kWhipPointValue,
                [kTechDataTooltipInfo] = "WHIP_TOOLTIP",
                [kTechDataGrows] = true,
                [kTechDataMaxAmount] = 3,
            })
        end
        
        if (kTechData[k][kTechDataId] == kTechId.Shift) then
            table.insert(tech, {
                [kTechDataId] = kTechId.GorgeShift,
                [kTechDataCategory] = kTechId.Gorge,
                [kTechDataAllowConsumeDrop] = false,
                [kTechDataMaxAmount] = 3,
                [kTechDataBioMass] = kShiftBiomass,
                [kTechDataSupply] = kShiftSupply,
                [kTechDataHint] = "SHIFT_HINT",
                [kTechDataGhostModelClass] = "AlienGhostModel",
                [kTechDataMapName] = GorgeShift.kMapName,
                [kTechDataDisplayName] = "SHIFT",
                [kTechDataRequiresInfestation] = true,
                [kTechDataCostKey] = kGorgeShiftCost,
                [kTechDataHotkey] = Move.S,
                [kTechDataBuildTime] = kShiftBuildTime,
                [kTechDataModel] = Shift.kModelName,
                [kTechDataMaxHealth] = kShiftHealth,
                [kTechDataMaxArmor] = kShiftArmor,
                [kTechDataInitialEnergy] = kShiftInitialEnergy,
                [kTechDataMaxEnergy] = kShiftMaxEnergy,
                [kTechDataPointValue] = kShiftPointValue,
                [kVisualRange] = {
                    kEchoRange,
                    kEnergizeRange
                },
                [kTechDataTooltipInfo] = "SHIFT_TOOLTIP",
                [kTechDataGrows] = true,
            })
        end
        if (kTechData[k][kTechDataId] == kTechId.Shade) then
            table.insert(tech, {
                [kTechDataId] = kTechId.GorgeShade,
                [kTechDataCategory] = kTechId.Gorge,
                [kTechDataAllowConsumeDrop] = false,
                [kTechDataMaxAmount] = 3,
                [kTechDataBioMass] = kShadeBiomass,
                [kTechDataSupply] = kShadeSupply,
                [kTechDataHint] = "SHADE_HINT",
                [kTechDataGhostModelClass] = "AlienGhostModel",
                [kTechDataMapName] = GorgeShade.kMapName,
                [kTechDataDisplayName] = "SHADE",
                [kTechDataCostKey] = kGorgeShadeCost,
                [kTechDataRequiresInfestation] = true,
                [kTechDataBuildTime] = kShadeBuildTime,
                [kTechDataHotkey] = Move.D,
                [kTechDataModel] = Shade.kModelName,
                [kTechDataMaxHealth] = kShadeHealth,
                [kTechDataMaxArmor] = kShadeArmor,
                [kTechDataInitialEnergy] = kShadeInitialEnergy,
                [kTechDataMaxEnergy] = kShadeMaxEnergy,
                [kTechDataPointValue] = kShadePointValue,
                [kVisualRange] = Shade.kCloakRadius,
                [kTechDataMaxExtents] = Vector(1, 1.3, .4),
                [kTechDataTooltipInfo] = "SHADE_TOOLTIP",
                [kTechDataGrows] = true,
            })
        end
        if (kTechData[k][kTechDataId] == kTechId.Clog) then
            table.insert(tech, {
                [kTechDataId] = kTechId.GorgeTunnel,
                [kTechDataCategory] = kTechId.Gorge,
                [kTechDataMaxExtents] = Vector(1.2, 1.2, 1.2),
                [kTechDataTooltipInfo] = "GORGE_TUNNEL_TOOLTIP",
                [kTechDataGhostModelClass] = "AlienGhostModel",
                [kTechDataAllowConsumeDrop] = true,
                [kTechDataAllowStacking] = false,
                [kTechDataMaxAmount] = kNumGorgeTunnels,
                [kTechDataMapName] = TunnelEntrance.kMapName,
                [kTechDataDisplayName] = "TUNNEL_ENTRANCE",
                [kTechDataHint] = "TUNNEL_ENTRANCE_HINT",
                [kTechDataCostKey] = kGorgeTunnelCost,
                [kTechDataMaxHealth] = kTunnelEntranceHealth,
                [kTechDataMaxArmor] = kTunnelEntranceArmor,
                [kTechDataBuildTime] = kGorgeTunnelBuildTime,
                [kTechDataModel] = TunnelEntrance.kModelName,
                [kTechDataRequiresInfestation] = false,
                [kTechDataPointValue] = kTunnelEntrancePointValue,
            })
            table.insert(tech, {
                [kTechDataId] = kTechId.GorgeTunnelTech,
                [kTechDataDisplayName] = "GORGE_TUNNEL_TECH",
                [kTechDataTooltipInfo] = "GORGE_TUNNEL_TECH_TOOLTIP",
                [kTechDataCostKey] = kGorgeTunnelResearchCost,
                [kTechDataResearchTimeKey] = kGorgeTunnelResearchTime,
            })
        end
    
        if (kTechData[k][kTechDataId] == kTechId.DropExosuit) then
            table.insert(tech, {
                [kTechDataId] = kTechId.DropSentry,
                [kTechDataMapName] = BuildSentry.kMapName,
                [kTechDataDisplayName] = "Sentry",
                [kTechDataModel] = Sentry.kModelName
            })
            
            table.insert(tech, {
                [kTechDataId] = kTechId.BuildSentry,
                [kTechDataMapName] = BuildSentry.kMapName,
                [kTechDataDisplayName] = "Sentry"
            })
        end
    
    end
    return tech
end