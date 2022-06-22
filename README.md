
Mensaje ligero de reglas para  No More Room in Hell.

Muestra un mensaje despues de que aparezca el "Join Game" con las reglas (NO NECESARIAMENTE PUEDEN SER REGLAS). 
Incluye un comando para determinar cuantos dias "N" se puede mostrar el mensaje (Configurable).

![nmrih_FaJop3qLwm](https://user-images.githubusercontent.com/11559683/115821664-93553e00-a3d9-11eb-957d-8bccc9d4b219.png)


# Requisitos
Sourcemod 1.10 o superior.

# Instalacion
- Colocar el archivo `nmrih-rules-menu.smx` en `addons/sourcemod/plugins`
- Colocar el archivo `nmrih-rules-menu.phrases.txt` en `addons/sourcemod/translations`

- Puedes modificar el archivo `nmrih-rules-menu.phrases.txt`. El reglamento siempre empieza con la orden 0.

```cpp
"Phrases"
{
	// ...

	"0"
	{
		"en"	"Rule 1"
		"ko"	"새우 금지"
		"es"	"Regla 1 "
	}

	"1"
	{
		"en"	"..."
		"es"	"..."
	}
}
```

# ConVars y comandos

- `sm_rules_acknowledge_expire_days` (Default: 90)
	- Dias que el mensaje les aparecerá a los usuarios. Por defecto es 90 dias

- `sm_rules_cmds` (Default: "sm_rules")
	- Lista separada por espacios de los comandos de la consola que deberían mostrar las reglas. Recomendable no tocar. Dejarlo como sm_rules

- `sm_rules_refresh` (Requires ADMFLAG_GENERIC)
	- Refresca la actualizacion de las reglas. Al cambiar de mapa se actualizará a la fuerza.
