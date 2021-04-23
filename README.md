
Simple lightweight server rules menu for No More Room in Hell.

Displays server rules as a radio menu to players after they press "Join Game". 

Players who acknowledge the rules won't be prompted again for N (configurable) days.


# Requirements
Sourcemod 1.10 or above

# Setup
- Place `nmrih-rules-menu.smx` in `addons/sourcemod/plugins`
- Place `nmrih-rules-menu.phrases.txt` in `addons/sourcemod/translations`

- Add your rules to `nmrih-rules-menu.phrases.txt`. Keys should be consecutive numbers starting from 0.

```cpp
"Phrases"
{
	// ...

	"0"
	{
		"en"	"No shrimps"
		"ko"	"새우 금지"
	}

	"1"
	{
		"en"	"..."
		"es"	"..."
	}
}
```

# ConVars and commands

- `sm_rules_acknowledge_expire_days` (Default: 90)
	- Days to wait after a player has acknowledged the rules before showing them again

- `sm_rules_cmds` (Default: "sm_rules")
	- Space-separated list of console commands that should bring up the rules

- `sm_rules_refresh` (Requires ADMFLAG_GENERIC)
	- Refresh rules cache
