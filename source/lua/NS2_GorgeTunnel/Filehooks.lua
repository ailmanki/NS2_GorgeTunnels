
ModLoader.SetupFileHook( "lua/NS2Utility.lua",			"lua/NS2_GorgeTunnel/NS2Utility.lua", "post" )
ModLoader.SetupFileHook( "lua/PlayingTeam.lua",			"lua/NS2_GorgeTunnel/PlayingTeam.lua", "post" )
ModLoader.SetupFileHook( "lua/TeamInfo.lua", 			"lua/NS2_GorgeTunnel/TeamInfo.lua", "post" )
ModLoader.SetupFileHook( "lua/TechTreeConstants.lua", 	"lua/NS2_GorgeTunnel/TechTreeConstants.lua", "post" )
ModLoader.SetupFileHook( "lua/TechData.lua", 			"lua/NS2_GorgeTunnel/TechData.lua", "post" )

ModLoader.SetupFileHook( "lua/GUIActionIcon.lua", 	"lua/NS2_GorgeTunnel/GUIActionIcon.lua", "replace" )
ModLoader.SetupFileHook( "lua/GUIPickups.lua", 	"lua/NS2_GorgeTunnel/GUIPickups.lua", "replace" )
ModLoader.SetupFileHook( "lua/GUIMarineBuyMenu.lua", 	"lua/NS2_GorgeTunnel/GUIMarineBuyMenu.lua", "post" )
ModLoader.SetupFileHook( "lua/Player.lua", 	"lua/NS2_GorgeTunnel/Player.lua", "post" )

ModLoader.SetupFileHook( "lua/TechTreeButtons.lua", 	"lua/NS2_GorgeTunnel/TechTreeButtons.lua", "post" )
ModLoader.SetupFileHook( "lua/AlienTeam.lua",			"lua/NS2_GorgeTunnel/AlienTeam.lua", "post" )
ModLoader.SetupFileHook( "lua/Balance.lua",				"lua/NS2_GorgeTunnel/Balance.lua", "post" )
ModLoader.SetupFileHook( "lua/Crag.lua",				"lua/NS2_GorgeTunnel/Crag.lua", "post" )
ModLoader.SetupFileHook( "lua/Shade.lua",				"lua/NS2_GorgeTunnel/Shade.lua", "post" )
ModLoader.SetupFileHook( "lua/Shift.lua",				"lua/NS2_GorgeTunnel/Shift.lua", "post" )
ModLoader.SetupFileHook( "lua/Whip.lua", 				"lua/NS2_GorgeTunnel/Whip.lua", "post" )
--ModLoader.SetupFileHook( "lua/CommanderHelp.lua",		"lua/NS2_GorgeTunnel/CommanderHelp.lua", "replace" )
ModLoader.SetupFileHook( "lua/GUIGorgeBuildMenu.lua",	"lua/NS2_GorgeTunnel/GUIGorgeBuildMenu.lua", "replace" )
ModLoader.SetupFileHook( "lua/NetworkMessages.lua", 	"lua/NS2_GorgeTunnel/NetworkMessages.lua", "post" )
ModLoader.SetupFileHook( "lua/Tunnel.lua", 				"lua/NS2_GorgeTunnel/Tunnel.lua", "post" )
ModLoader.SetupFileHook( "lua/TunnelEntrance.lua", 		"lua/NS2_GorgeTunnel/TunnelEntrance.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Alien/DropStructureAbility.lua", "lua/NS2_GorgeTunnel/Weapons/Alien/DropStructureAbility.lua", "replace" )
ModLoader.SetupFileHook( "lua/MarineActionFinderMixin.lua", "lua/NS2_GorgeTunnel/MarineActionFinderMixin.lua", "post" )
--ModLoader.SetupFileHook( "lua/DigestMixin.lua", 		"lua/NS2_GorgeTunnel/DigestMixin.lua", "post" )

-- Allows Gorge Tunnel in Combat
ModLoader.SetupFileHook( "lua/Combat/Globals.lua","lua/NS2_GorgeTunnel/BalanceCombat.lua", "post" )
-- Make Gorge Toys a target for arcs in combat
ModLoader.SetupFileHook( "lua/Combat/FileHooks/Post/ARC.lua","lua/NS2_GorgeTunnel/Combat/FileHooks/Post/ARC.lua", "replace" )
-- On certain "reset" event destroy gorge structures from the player
ModLoader.SetupFileHook( "lua/Combat/Player_Upgrades.lua","lua/NS2_GorgeTunnel/Combat/Player_Upgrades.lua", "post" )


-- add sentry to combat!
ModLoader.SetupFileHook( "lua/Combat/ExperienceData.lua", "lua/NS2_GorgeTunnel/Combat/ExperienceData.lua", "post" )
ModLoader.SetupFileHook( "lua/Combat/ExperienceEnums.lua", "lua/NS2_GorgeTunnel/Combat/ExperienceEnums.lua", "post" )
ModLoader.SetupFileHook( "lua/Combat/MarineBuyFuncs.lua", "lua/NS2_GorgeTunnel/Combat/MarineBuyFuncs.lua", "post" )
--ModLoader.SetupFileHook( "lua/Combat/Player_Upgrades.lua", "lua/ShieldGenerator/Combat/Player_Upgrades.lua", "post" )
--ModLoader.SetupFileHook( "lua/Combat/FileHooks/Post/Player_Server.lua", "lua/ShieldGenerator/Combat/Player_Server.lua", "post" )
--ModLoader.SetupFileHook( "lua/Combat/FileHooks/Post/Weapons/Marine/LayMines.lua", "lua/NS2_GorgeTunnel/Weapons/Marine/BuildSentry.lua", "post" )
--ModLoader.SetupFileHook( "lua/Marine.lua", "lua/Marine.lua", "post" )
--ModLoader.SetupFileHook( "lua/Player.lua", "lua/Player.lua", "post" )