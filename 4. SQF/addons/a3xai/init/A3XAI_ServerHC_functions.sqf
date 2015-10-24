diag_log "[A3XAI] Compiling A3XAI HC functions.";

//Server-only
A3XAI_transferGroupToHC = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient_server\A3XAI_transferGroupToHC.sqf",A3XAI_directory];
A3XAI_HCGroupToServer = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient_server\A3XAI_transferGroupToServer.sqf",A3XAI_directory];
A3XAI_getGroupTriggerVars = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient_server\A3XAI_getGroupTriggerVars.sqf",A3XAI_directory];
A3XAI_updateGroupLootPool = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient_server\A3XAI_updateGroupLootPool.sqf",A3XAI_directory];
A3XAI_HCListener = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient_server\A3XAI_HCListener.sqf",A3XAI_directory];
A3XAI_updateGroupSizeServer = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient_server\A3XAI_updateGroupSizeServer.sqf",A3XAI_directory];
A3XAI_registerDeath = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient_server\A3XAI_registerDeath.sqf",A3XAI_directory];
A3XAI_protectRemoteGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient_server\A3XAI_protectRemoteGroup.sqf",A3XAI_directory];
A3XAI_setBehavior = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient_server\A3XAI_setBehavior.sqf",A3XAI_directory];

diag_log "[A3XAI] A3XAI HC functions compiled.";