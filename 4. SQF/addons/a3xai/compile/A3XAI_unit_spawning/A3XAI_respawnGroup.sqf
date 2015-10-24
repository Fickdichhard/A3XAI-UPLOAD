#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_trigger","_patrolDist","_spawnPositions","_spawnPos","_startTime","_maxUnits","_totalAI","_aiGroup","_unitLevel","_unitLevelEffective", "_checkPos","_spawnRadius",
"_unitType","_spawnChance","_playerDistNoLOS","_playerDistWithLOS","_isCustomGroup"];

_startTime = diag_tickTime;

_unitGroup = _this select 0;
_trigger = _this select 1;
_maxUnits = _this select 2;

_patrolDist = _trigger getVariable ["patrolDist",150];
_unitLevel = _trigger getVariable ["unitLevel",1];
_unitLevelEffective = _trigger getVariable ["unitLevelEffective",1];
_spawnPositions = _trigger getVariable ["locationArray",[]];

//Check unit type
_unitType = _unitGroup getVariable ["unitType",""];
if (_unitType isEqualTo "") then {
	_unitType = _trigger getVariable ["spawnType",""];
	_unitGroup setVariable ["unitType",_unitType];
};

_isCustomGroup = _trigger getVariable ["isCustom",false];
_playerDistWithLOS = if (_isCustomGroup) then {PLAYER_DISTANCE_WITH_LOS_STATIC_CUSTOM} else {PLAYER_DISTANCE_WITH_LOS_STATIC};
_playerDistNoLOS = if (_isCustomGroup) then {PLAYER_DISTANCE_NO_LOS_STATIC_CUSTOM} else {PLAYER_DISTANCE_NO_LOS_STATIC};

_totalAI = 0;
_spawnPos = [];
_checkPos = false;
_spawnChance = if (_isCustomGroup) then {_trigger getVariable ["spawnChance",1]} else {(_trigger getVariable ["spawnChance",1]) * A3XAI_spawnChanceMultiplier};

if (_spawnChance call A3XAI_chance) then {
	_totalAI = ((_maxUnits select 0) + round(random (_maxUnits select 1)));
	if ((count _spawnPositions) > 0) then {
		_spawnPos = _spawnPositions call A3XAI_findSpawnPos;
	} else {
		_checkPos = true;
		_attempts = 0;
		_continue = true;
		_spawnRadius = _patrolDist;

		while {_continue && {(_attempts < 3)}} do {
			_spawnPosSelected = [(getPosATL _trigger),random (_spawnRadius),random(360),0] call A3XAI_SHK_pos;
			_spawnPosSelASL = ATLToASL _spawnPosSelected;
			if ((count _spawnPosSelected) isEqualTo 2) then {_spawnPosSelected set [2,0];};
			if (
				!((_spawnPosSelASL) call A3XAI_posInBuilding) && 
				{({if ((isPlayer _x) && {([eyePos _x,[(_spawnPosSelected select 0),(_spawnPosSelected select 1),(_spawnPosSelASL select 2) + 1.7],_x] call A3XAI_hasLOS) or ((_x distance _spawnPosSelected) < _playerDistNoLOS)}) exitWith {1}} count (_spawnPosSelected nearEntities [[PLAYER_UNITS,"LandVehicle"],_playerDistWithLOS])) isEqualTo 0}
			) then {
				_spawnPos = _spawnPosSelected;
				_continue = false;
			} else {
				_attempts = _attempts + 1;
				_spawnRadius = _spawnRadius + 25;
				if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Unable to find suitable spawn position. (attempt %1/3).",_attempts];};
			};
		};
	};
};

if ((_totalAI < 1) or {_spawnPos isEqualTo []}) exitWith {
	//_unitGroup setVariable ["GroupSize",0];
	[0,_trigger,_unitGroup,true] call A3XAI_addRespawnQueue;
	false
};

_aiGroup = [_totalAI,_unitGroup,_unitType,_spawnPos,_trigger,_unitLevelEffective,_checkPos] call A3XAI_spawnGroup;
if (isNull _unitGroup) then {diag_log format ["A3XAI Error: Respawned group at %1 was null group. New group reassigned: %2.",triggerText _trigger,_aiGroup]; _unitGroup = _aiGroup};
//if (_unitLevel != _unitLevelEffective) then {_trigger setVariable ["unitLevelEffective",_unitLevel]}; //Reset unitLevel after respawning promoted group
if (_patrolDist > 1) then {
	if ((count (waypoints _unitGroup)) > 1) then {
		_unitGroup setCurrentWaypoint ((waypoints _unitGroup) call A3XAI_selectRandom);
	} else {
		_nul = [_unitGroup,(getPosATL _trigger),_patrolDist] spawn A3XAI_BIN_taskPatrol;
	};
} else {
	[_unitGroup, 0] setWaypointType "GUARD";
};

if (_unitType in A3XAI_airReinforcementAllowedFor) then {
	_unitGroup setVariable ["ReinforceAvailable",true];
};

if (A3XAI_enableDebugMarkers) then {
	_nul = _trigger call A3XAI_addMapMarker;
};

if (A3XAI_debugLevel > 0) then {diag_log format["A3XAI Debug: %1 AI units respawned for group %2 (unitLevel %3) at %4 in %5 seconds (respawnBandits).",_totalAI,_unitGroup,_unitLevelEffective,(triggerText _trigger),diag_tickTime - _startTime];};

true
