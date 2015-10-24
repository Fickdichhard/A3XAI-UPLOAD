"A3XAI_transferGroup_PVC" addPublicVariableEventHandler {(_this select 1) call A3XAI_addNewGroup;diag_log format ["Debug: %1",_this];};
"A3XAI_sendGroupTriggerVars_PVC" addPublicVariableEventHandler {_nul = (_this select 1) spawn A3XAI_setGroupTriggerVars;diag_log format ["Debug: %1",_this];};
"A3XAI_updateGroupLoot_PVC" addPublicVariableEventHandler {(_this select 1) call A3XAI_updateGroupLootPoolHC;diag_log format ["Debug: %1",_this];};
"A3XAI_sendHunterGroup_PVC" addPublicVariableEventHandler {(_this select 1) call A3XAI_addHunterGroup;diag_log format ["Debug: %1",_this];};
"A3XAI_updateGroupSize_PVC" addPublicVariableEventHandler {(_this select 1) call A3XAI_updateGroupSizeHC;diag_log format ["Debug: %1",_this];};
"A3XAI_setCurrentWaypoint_PVC" addPublicVariableEventHandler {(_this select 1) call A3XAI_setCurrentWaypointHC;diag_log format ["Debug: %1",_this];};
"A3XAI_cleanupReinforcement_PVC" addPublicVariableEventHandler {(_this select 1) spawn A3XAI_cleanupReinforcementHC;diag_log format ["Debug: %1",_this];};
"A3XAI_setBehavior_PVC" addPublicVariableEventHandler {(_this select 1) call A3XAI_setBehaviorHC;diag_log format ["Debug: %1",_this];};
"A3XAI_requestVehicleRelease_PVC" addPublicVariableEventHandler {(_this select 1) call A3XAI_releaseVehicleAllow;diag_log format ["Debug: %1",_this];};

diag_log "[A3XAI] A3XAI HC PVEHs loaded.";

true
