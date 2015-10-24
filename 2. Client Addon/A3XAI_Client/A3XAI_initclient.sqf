if (hasInterface) then {
	_nul = [] spawn {
		waitUntil {uiSleep 1; alive player};
		waitUntil {uiSleep 1; (typeOf player) isEqualTo "Exile_Unit_Player"};
		#include "A3XAI_client_version.txt"

		call compile preprocessFileLineNumbers "A3XAI_Client\A3XAI_client_config.sqf";
		call compile preprocessFileLineNumbers "A3XAI_Client\A3XAI_client_verifySettings.sqf";
		call compile preprocessFileLineNumbers "A3XAI_Client\A3XAI_client_functions.sqf";

		if (A3XAI_client_radio) then {
			"A3XAI_SMS" addPublicVariableEventHandler {(_this select 1) call A3XAI_client_radioMessage; diag_log _this;};
		};

		//No longer needed, A3XAI sends kill messages through Exile's messaging system nonglobally.
		/*
		if (A3XAI_client_deathMessages) then {
			"A3XAI_killMSG" addPublicVariableEventHandler {(_this select 1) call A3XAI_client_killMessage; diag_log _this;};
		};
		*/

		diag_log format ["[A3XAI] Initialized %1 version %2. Radio enabled: %3.",A3XAI_CLIENT_TYPE,A3XAI_CLIENT_VERSION,A3XAI_client_radio];
	};
	
};
