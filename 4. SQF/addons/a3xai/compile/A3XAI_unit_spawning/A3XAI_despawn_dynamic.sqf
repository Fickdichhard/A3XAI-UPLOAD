#include "\A3XAI\globaldefines.hpp"

private ["_trigger","_triggerLocation","_isForceDespawn","_grpArray","_canDespawn","_triggerExists","_triggerStatements","_deactStatements"];

_trigger = _this select 0;										//Get the trigger object
_isForceDespawn = if ((count _this) > 1) then {_this select 1} else {false};

_triggerStatements = triggerStatements _trigger;
_grpArray = _trigger getVariable ["GroupArray",[]];				//Find the groups spawned by the trigger. Or set an empty group array if none are found.

if ((_trigger getVariable ["isCleaning",false]) && (!_isForceDespawn)) exitWith {if (A3XAI_debugLevel > 1) then {diag_log "A3XAI Debug: Despawn script is already running. Exiting despawn script.";};};

_trigger setVariable["isCleaning",true];			//Mark the trigger as being in a cleanup state so that subsequent requests to despawn for the same trigger will not run.
_deactStatements = _triggerStatements select 2;
_trigger setTriggerStatements (_triggerStatements set [2,""]);
_canDespawn = true;
_triggerExists = true;


if (_isForceDespawn) then {
	_trigger setTriggerStatements ["this","",""];
	if (A3XAI_debugLevel > 0) then {diag_log format["A3XAI Debug: All units of dynamic AI group spawned by trigger %1 have been killed. Starting force despawn in 30 seconds.",triggerText _trigger];};
	uiSleep 30;
} else {
	if (A3XAI_debugLevel > 0) then {diag_log format["A3XAI Debug: No players remain in %1. Deleting spawned AI in %2 seconds.",triggerText _trigger,A3XAI_despawnDynamicSpawnTime];};
	if (A3XAI_enableDebugMarkers) then {
		_nul = _trigger spawn {
			_marker = str(_this);
			_marker setMarkerColor "ColorGreen";
			_marker setMarkerAlpha 0.7;							//Light green: Active trigger awaiting despawn.
		};
	};
	uiSleep A3XAI_despawnDynamicSpawnTime;								//Wait some time before deleting units. (amount of time to allow units to exist when the trigger area has no players)

	if !(isNull _trigger) then {							//Check if dynamic spawn area has been force-despawned (deleted). Force despawn will happen when all units have been killed.
		_canDespawn = ((!triggerActivated _trigger) or {isNull (_grpArray select 0)});			//Can despawn dynamic spawn area if trigger isn't activated or spawned group is null
	} else {
		_triggerExists = false;
	};
};

if !(_triggerExists) exitWith {};							//Cancel despawn process if it has already happened

if (_canDespawn) then {
	_trigger setTriggerStatements ["this","",""]; //temporarily disable trigger from activating or deactivating while cleanup is performed
	_grpArray = _grpArray - [grpNull];
	{
		if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Deleting group %1 with %2 active units.",_x,(_x getVariable ["GroupSize",0])];};
		_x setVariable ["GroupSize",-1];
		if (A3XAI_HCIsConnected) then {
			A3XAI_updateGroupSize_PVC = [_x,-1];
			A3XAI_HCObjectOwnerID publicVariableClient "A3XAI_updateGroupSize_PVC";
		};
	} forEach _grpArray;
	
	//Remove dynamic trigger from global dyn trigger array and clean up trigger
	[_trigger,"A3XAI_dynTriggerArray"] call A3XAI_updateSpawnCount;
	if (A3XAI_enableDebugMarkers) then {deleteMarker str(_trigger)};

	//Begin deletion timer for temporary blacklist area and add it to global dyn location array to allow deletion
	_triggerLocation = _trigger getVariable "triggerLocation";
	_triggerLocation setVariable ["deletetime",(diag_tickTime + A3XAI_tempBlacklistTime)];
	A3XAI_areaBlacklists pushBack _triggerLocation;

	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Removing expired dynamic trigger at %1.",mapGridPosition _trigger];};
	deleteVehicle _trigger;
	
	true
} else {
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: A player has entered the trigger area at %1. Cancelling despawn.",(triggerText _trigger)];}; //Exit script if trigger has been reactivated since A3XAI_despawnDynamicSpawnTime seconds has passed.
	_trigger setVariable ["isCleaning",false];	//Allow next despawn request.
	_triggerStatements set [2,_deactStatements];
	_trigger setTriggerStatements _triggerStatements;
	if (A3XAI_enableDebugMarkers) then {
		_nul = _trigger spawn {
			_marker = str(_this);
			_marker setMarkerColor "ColorOrange";
			_marker setMarkerAlpha 0.9;						//Reset trigger indicator color to Active.
		};
	};
	false
};