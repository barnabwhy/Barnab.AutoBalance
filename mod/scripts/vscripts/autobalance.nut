global function AutoBalance_Init

array<string> disabledGamemodes = ["private_match", "inf", "hs", "ffa"]
array<string> disabledMaps = ["mp_lobby"]

void function AutoBalance_Init()
{
	thread AutoBalanceGame()
}


void function AutoBalanceGame()
{
	while (true)
	{
		float interval = GetConVarFloat("autobal_interval")
		if(interval > 0.0)
			wait interval
		else
			WaitFrame()

		bool debug = GetConVarBool("autobal_debug")
		int threshold = GetConVarInt("autobal_threshold")
		if (threshold < 1) {
			threshold = 1
		}

		// Check if the gamemode or map are on the blacklist
		bool gamemodeDisable = disabledGamemodes.find(GAMETYPE) > -1;
		bool mapDisable = disabledMaps.find(GetMapName()) > -1;
		// Only run the code if the blacklists were passed
		if( debug || !(gamemodeDisable || mapDisable) ) {
			array<entity> imc = GetPlayerArrayOfTeam( TEAM_IMC )
			array<entity> militia = GetPlayerArrayOfTeam( TEAM_MILITIA )

			// Don't run if there are no players
			if ( !(imc.len() == 0 && militia.len() == 0 )) {
				if( debug || (imc.len() >= militia.len() + threshold) || (militia.len() >= imc.len() + threshold) )
				{
					printt("[AUTOBALANCE] Teams aren't balanced (IMC: " + imc.len() + ", MILITIA: " + militia.len() + ")")
					if (imc.len() > militia.len())
					{
						// If team IMC has more players than team MILITIA switch some players
						int toSwitch = ( ( imc.len() - militia.len() ) / 2 ).tointeger()
						if(toSwitch < 1)
							toSwitch = 1

						printt("[AUTOBALANCE] " + toSwitch + " IMC players will be team balanced.")

						for (int i = 0; i < toSwitch; i++)
						{
							imc = GetPlayerArrayOfTeam( TEAM_IMC )
							int playerIndex = RandomIntRange(0, imc.len())
							printt("[AUTOBALANCE] IMC player " + playerIndex + " (" + imc[playerIndex].GetPlayerName() + ") will be team balanced.")
							SwitchTeam(imc[playerIndex])
						}
					}
					else
					{
						// If team IMC has more players than team MILITIA switch some players
						int toSwitch = ( ( militia.len() - imc.len() ) / 2 ).tointeger()
						if(toSwitch < 1)
							toSwitch = 1

						printt("[AUTOBALANCE] " + toSwitch + " MILITIA players will be team balanced.")

						for (int i = 0; i < toSwitch; i++)
						{
							militia = GetPlayerArrayOfTeam( TEAM_MILITIA )
							int playerIndex = RandomIntRange(0, militia.len())
							printt("[AUTOBALANCE] MILITIA player " + playerIndex + " (" + militia[playerIndex].GetPlayerName() + ") will be team balanced.")
							SwitchTeam(militia[playerIndex])
						}
					}
				}
				else
				{
					printt("[AUTOBALANCE] Teams are balanced (IMC: " + imc.len() + ", MILITIA: " + militia.len() + ")")
				}
			}
		}
	}
}

void function SwitchTeam(entity player)
{
#if SERVER
	try {
		if (player.GetTeam() == TEAM_IMC)
			SetTeam( player, TEAM_MILITIA )
		else if (player.GetTeam() == TEAM_MILITIA)
			SetTeam( player, TEAM_IMC )
		printt("[AUTOBALANCE] Switched " + player.GetPlayerName() + "'s team.")
	} catch(e)
	{
		printt("[AUTOBALANCE] Unable to switch " + player.GetPlayerName() + "'s team.")
	}
#endif
}
