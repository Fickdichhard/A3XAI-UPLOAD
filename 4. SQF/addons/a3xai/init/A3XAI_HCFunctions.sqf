diag_log "[A3XAI] Compiling A3XAI HC functions.";

//HC-only
A3XAI_setGroupTriggerVars = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_setGroupTriggerVars.sqf",A3XAI_directory]; 
A3XAI_handlestatic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handlestatic.sqf",A3XAI_directory]; 
A3XAI_handlestaticcustom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handlestaticcustom.sqf",A3XAI_directory]; 
A3XAI_handleland = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handleland.sqf",A3XAI_directory]; 
A3XAI_handleair = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handleair.sqf",A3XAI_directory]; 
A3XAI_handleaircustom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handleaircustom.sqf",A3XAI_directory]; 
A3XAI_handleair_reinforce = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handleair_reinforce.sqf",A3XAI_directory];
A3XAI_handlelandcustom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handlelandcustom.sqf",A3XAI_directory]; 
A3XAI_handledynamic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handledynamic.sqf",A3XAI_directory]; 
A3XAI_handlerandom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handlerandom.sqf",A3XAI_directory]; 
A3XAI_handleuav = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handleuav.sqf",A3XAI_directory]; 
A3XAI_handleugv = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handleugv.sqf",A3XAI_directory]; 
A3XAI_handlevehiclecrew = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_handlevehiclecrew.sqf",A3XAI_directory]; 
A3XAI_addNewGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_addNewGroup.sqf",A3XAI_directory]; 
A3XAI_addHunterGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_addHunterGroup.sqf",A3XAI_directory]; 
A3XAI_updateGroupSizeHC = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_updateGroupSizeHC.sqf",A3XAI_directory];
A3XAI_airReinforcementDetection = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_airReinforcementDetection.sqf",A3XAI_directory]; 
A3XAI_cleanupReinforcementHC = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_cleanupReinforcementHC.sqf",A3XAI_directory]; 
A3XAI_setLoadoutVariables_HC = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_setLoadoutVariables_HC.sqf",A3XAI_directory];
A3XAI_createGroupTriggerObject = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_createGroupTriggerObject.sqf",A3XAI_directory];
A3XAI_requestGroupVars = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_requestGroupVars.sqf",A3XAI_directory];
A3XAI_updateServerLoot = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_updateServerLoot.sqf",A3XAI_directory];
A3XAI_updateGroupLootPoolHC = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_updateGroupLootPoolHC.sqf",A3XAI_directory];
A3XAI_setBehaviorHC = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_headlessclient\A3XAI_setBehaviorHC.sqf",A3XAI_directory];

diag_log "[A3XAI] A3XAI HC functions loaded.";

true
