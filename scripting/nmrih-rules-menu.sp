#include <clientprefs>
 
#pragma semicolon 1

public Plugin myinfo = 
{
	name = "[NMRiH] Rules Menu",
	author = "Dysphie",
	description = "Lightweight rules menu",
	version = "0.1.1",
	url = ""
};

Cookie rulesCookie;
ConVar cvExpireDays;
ConVar cvCommands;

int maxRules;

public void OnPluginStart()
{
	LoadTranslations("nmrih-rules-menu.phrases");
	DiscoverRules();

	AddCommandListener(OnPlayerJoinGame, "joingame");
	rulesCookie = new Cookie("server_rules", "Server Rules Agreement", CookieAccess_Protected);

	RegAdminCmd("sm_rules_refresh", OnCmdReloadRules, ADMFLAG_GENERIC);
	cvExpireDays = CreateConVar("sm_rules_acknowledge_expire_days", "90");
	cvCommands = CreateConVar("sm_rules_cmds", "sm_rules sm_rulez");
	AutoExecConfig();
}

public void OnConfigsExecuted()
{
	char cmdString[2048];
	cvCommands.GetString(cmdString, sizeof(cmdString));
	RegisterCmds(cmdString);

	cvCommands.AddChangeHook(OnCmdsChanged);
}

public void OnCmdsChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	RegisterCmds(newValue);
}

void RegisterCmds(const char[] cmdstring)
{
	char cmds[10][128];
	int numCmds = ExplodeString(cmdstring, " ", cmds, sizeof(cmds), sizeof(cmds[]));

	for (int i; i < numCmds; i++)
		RegConsoleCmd(cmds[i], OnCmdRules);	
}

public Action OnCmdRules(int client, int args)
{
	ShowRules(client);
	return Plugin_Handled;
}

public Action OnCmdReloadRules(int client, int args)
{
	DiscoverRules();
	ReplyToCommand(client, "Rebuilt rules menu. %d rules found", maxRules);
}

public Action OnPlayerJoinGame(int client, const char[] command, int argc)
{
	if (0 < client <= MaxClients)
		RequestFrame(CheckShouldDisplayRules, GetClientSerial(client));

	return Plugin_Continue;
}

void CheckShouldDisplayRules(int clientSerial)
{
	if (maxRules < 1)
		return;

	int client = GetClientFromSerial(clientSerial);
	if (!client || !AreClientCookiesCached(client))
		return;

	// Expire cookie if it's been there for too long
	int daysSinceAck = (GetTime() - rulesCookie.GetClientTime(client)) / 86400;
	if (daysSinceAck > cvExpireDays.IntValue)
	{
		rulesCookie.Set(client, "0");
	}
	else
	{
		char cookieValue[2];
		GetClientCookie(client, rulesCookie, cookieValue, sizeof(cookieValue));
		if (cookieValue[0] == '1')
			return;
	}

	ShowRules(client);
}

void ShowRules(int client)
{
	if (!client)
		return;

	Menu menu = new Menu(OnRulesMenu);
	menu.SetTitle("%T", "Title", client);

	char buffer[512];
	for (int i; i < maxRules; i++)
	{
		IntToString(i, buffer, sizeof(buffer));
		Format(buffer, sizeof(buffer), "%T", buffer, client);
		menu.AddItem("", buffer, ITEMDRAW_DISABLED);
	}

	menu.Display(client, MENU_TIME_FOREVER);
}

public int OnRulesMenu(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_Exit && AreClientCookiesCached(param1))
			rulesCookie.Set(param1, "1");
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

void DiscoverRules()
{
	maxRules = 0;
	char buffer[6];

	for (;;)
	{
		IntToString(maxRules, buffer, sizeof(buffer));
		if (!TranslationPhraseExists(buffer))
			break;
		maxRules++;
	}
}
