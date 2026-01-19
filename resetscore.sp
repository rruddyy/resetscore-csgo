#include <sourcemod>
#include <cstrike>
#pragma newdecls required

public Plugin myinfo =
{
    name        = "ResetScore",
    author      = "Rudy",
    description = "Reset score global random message",
    version     = "1.5"
};

ConVar gCvarEnable;

// Array with random messages
char g_RandomMessages[][] = {
    "tocmai si-a resetat \x02scorul\x01.",
    "a decis sa o ia de la \x02zero\x01.",
    "vrea un \x02fresh start\x01.",
    "si-a sters \x02statisticile\x01.",
    "a apasat butonul de \x02reset\x01."
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_rs", Command_ResetScore);
    
    gCvarEnable = CreateConVar(
        "resetscore_enable",
        "1",
        "Enable / Disable reset score",
        FCVAR_NOTIFY,
        true, 0.0,
        true, 1.0
    );
    
    AutoExecConfig(true, "resetscore");
}

public Action Command_ResetScore(int client, int args)
{
    if (!client || !IsClientInGame(client))
        return Plugin_Handled;
    
    if (!gCvarEnable.BoolValue)
        return Plugin_Handled;
    
    // Reset the score
    SetEntProp(client, Prop_Data, "m_iFrags", 0);
    SetEntProp(client, Prop_Data, "m_iDeaths", 0);
    CS_SetClientAssists(client, 0);
    CS_SetMVPCount(client, 0);
    CS_SetClientContributionScore(client, 0);
    
    SendMessages(client);
    
    return Plugin_Handled;
}

void SendMessages(int client)
{
    char name[MAX_NAME_LENGTH];
    GetClientName(client, name, sizeof(name));
    
    // Message only for player
    PrintToChat(client,
        " \x02ELITEGAMING.RO \x01» Ti-ai resetat scorul cu \x02succes\x01."
    );
    
    // Choose a random message from the array
    int randomIndex = GetRandomInt(0, sizeof(g_RandomMessages) - 1);
    
    // Global message with random text
    PrintToChatAll(
        " \x02ELITEGAMING.RO \x01» \x02%s \x01%s",
        name,
        g_RandomMessages[randomIndex]
    );
}
