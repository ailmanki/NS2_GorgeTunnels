ModLoader.SetupFileHook( "lua/AlienTeam.lua", "lua/NS2_GorgeTunnel/AlienTeam.lua", "replace" )
ModLoader.SetupFileHook( "lua/Balance.lua", "lua/NS2_GorgeTunnel/Balance.lua", "post" )
ModLoader.SetupFileHook( "lua/CommanderHelp.lua", "lua/NS2_GorgeTunnel/CommanderHelp.lua", "replace" )
ModLoader.SetupFileHook( "lua/NS2Utility.lua", "lua/NS2_GorgeTunnel/NS2Utility.lua", "replace" )
ModLoader.SetupFileHook( "lua/PlayingTeam.lua", "lua/NS2_GorgeTunnel/PlayingTeam.lua", "replace" )
ModLoader.SetupFileHook( "lua/TeamInfo.lua", "lua/NS2_GorgeTunnel/TeamInfo.lua", "replace" )
ModLoader.SetupFileHook( "lua/TechData.lua", "lua/NS2_GorgeTunnel/TechData.lua", "replace" )
ModLoader.SetupFileHook( "lua/TechTreeButtons.lua", "lua/NS2_GorgeTunnel/TechTreeButtons.lua", "replace" )
ModLoader.SetupFileHook( "lua/Tunnel.lua", "lua/NS2_GorgeTunnel/Tunnel.lua", "replace" )
ModLoader.SetupFileHook( "lua/TunnelEntrance.lua", "lua/NS2_GorgeTunnel/TunnelEntrance.lua", "replace" )
ModLoader.SetupFileHook( "lua/Weapons/Alien/DropStructureAbility.lua", "lua/NS2_GorgeTunnel/Weapons/Alien/DropStructureAbility.lua", "replace" )

-- Allows Gorge Tunnel in Combat
ModLoader.SetupFileHook( "lua/Combat/Globals.lua", "lua/NS2_GorgeTunnel/BalanceCombat.lua", "post" )
