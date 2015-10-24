#include "\A3XAI\globaldefines.hpp"

private ["_startTime", "_totalAI", "_patrolDist", "_trigger", "_unitLevel", "_grpArray", "_triggerPos", "_maxUnits", "_attempts", "_continue", "_spawnPos", "_spawnPosSelected", "_unitGroup", "_triggerStatements","_spawnRadius"];

_startTime = diag_tickTime;

_totalAI = _this select 0;									
//_this select 1;
_patrolDist = _this select 2;								
_trigger = _this select 3;									
_unitLevel = _this select 4;

_grpArray = _trigger getVariable ["GroupArray",[]];	
if !(_grpArray isEqualTo []) exitWith {if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Active groups found at custom spawn %1. Exiting spawn script.",(triggerText _trigger)];};};						

_trigger setTriggerArea [TRIGGER_SIZE_EXPANDED,TRIGGER_SIZE_EXPANDED,0,false];
_triggerPos = getPosATL _trigger;

_startTime = diag_tickTime;

if !(_trigger getVariable ["respawn",true]) then {
	_maxUnits = _trigger getVariable ["maxUnits",[0,0]];
	if !(_maxUnits isEqualTo [0,0]) then {_totalAI = (_maxUnits select 0)};	//Retrieve AI amount if it was updated from initial value (for non-respawning custom spawns only)
};

_attempts = 0;
_continue = true;
_spawnPos = [];
_spawnRadius = _patrolDist;
while {_continue && {(_attempts < 3)}} do {
	_spawnPosSelected = [_triggerPos,random (_patrolDist),random(360),0] call A3XAI_SHK_pos;
	_spawnPosSelASL = ATLToASL _spawnPosSelected;
	if ((count _spawnPosSelected) isEqualTo 2) then {_spawnPosSelected set [2,0];};
	if (
		!(_spawnPosSelASL call A3XAI_posInBuilding) && 
		{({if ((isPlayer _x) && {([eyePos _x,[(_spawnPosSelected select 0),(_spawnPosSelected select 1),(_spawnPosSelASL select 2) + 1.7],_x] call A3XAI_hasLOS) or ((_x distance _spawnPosSelected) < PLAYER_DISTANCE_NO_LOS_STATIC_CUSTOM)}) exitWith {1}} count (_spawnPosSelected nearEntities [[PLAYER_UNITS,"LandVehicle"],PLAYER_DISTANCE_WITH_LOS_STATIC_CUSTOM])) isEqualTo 0}
	) then {
		_spawnPos = _spawnPosSelected;
		_continue = false;
	} else {
		_attempts = _attempts + 1;
		_spawnRadius = _spawnRadius + 25;
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Unable to find suitable spawn position. (attempt %1/3).",_attempts];};
	};
};

_unitGroup = grpNull;
try {
	if !(_spawnPos isEqualTo []) then {
		_unitGroup = [_totalAI,_unitGroup,"staticcustom",_spawnPos,_trigger,_unitLevel,true] call A3XAI_spawnGroup;
		if (isNull _unitGroup) then {
			throw format ["A3XAI Debug: Custom static group spawn position too close to a player at %1. Spawn cancelled.",_spawnPos];
		};
		if (_patrolDist > 1) then {
			0 = [_unitGroup,_triggerPos,_patrolDist] spawn A3XAI_BIN_taskPatrol;
		} else {
			[_unitGroup, 0] setWaypointType "HOLD";
		};

		if (A3XAI_debugLevel > 0) then {diag_log format["A3XAI Debug: Spawned a group of %1 units in %2 seconds at custom spawn %3.",_totalAI,(diag_tickTime - _startTime),(triggerText _trigger)];};
	} else {
		throw format["A3XAI Debug: Unable to find suitable spawn position at custom spawn %1.",(triggerText _trigger)];
	};
} catch {
	_unitGroup = ["staticcustom",true] call A3XAI_createGroup;
	_unitGroup setVariable ["GroupSize",0];
	_unitGroup setVariable ["trigger",_trigger];
	[0,_trigger,_unitGroup,true] call A3XAI_addRespawnQueue;
	if (A3XAI_debugLevel > 0) then {
		diag_log _exception;
	};
};

_grpArray pushBack _unitGroup;

_unitGroup
