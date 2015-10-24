#include "\A3XAI\globaldefines.hpp"

private ["_minAI","_addAI","_patrolDist","_trigger","_unitLevel","_numGroups","_grpArray","_triggerPos","_startTime","_totalSpawned","_triggerStatements","_groupsActive","_spawnChance"];

_minAI = _this select 0;									//Mandatory minimum number of AI units to spawn
_addAI = _this select 1;									//Maximum number of additional AI units to spawn
_patrolDist = _this select 2;								//Patrol radius from trigger center.
_trigger = _this select 3;									//The trigger calling this script.
//_positionArray = _this select 4;							//Array of manually-defined spawn points (markers). If empty, nearby buildings are used as spawn points.
_unitLevel = if ((count _this) > 5) then {_this select 5} else {1};		//(Optional) Select the item probability table to use
_numGroups = if ((count _this) > 6) then {_this select 6} else {1};		//(Optional) Number of groups of x number of units each to spawn

_startTime = diag_tickTime;

_grpArray = _trigger getVariable ["GroupArray",[]];	
_groupsActive = count _grpArray;

_trigger setTriggerArea [TRIGGER_SIZE_EXPANDED,TRIGGER_SIZE_EXPANDED,0,false]; //Expand trigger area to prevent players from quickly leaving and start respawn process immediately
_triggerPos = getPosATL _trigger;

//If trigger already has defined spawn points, then reuse them instead of recalculating new ones.
_locationArray = _trigger getVariable ["locationArray",[]];	
_totalSpawned = 0;

//Spawn groups
if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Trigger %1 is spawning units...",triggerText _trigger]};
for "_j" from 1 to (_numGroups - _groupsActive) do {
	private ["_unitGroup","_spawnPos","_totalAI"];
	_totalAI = 0;
	_spawnPos = [];
	_spawnChance = ((_trigger getVariable ["spawnChance",1]) * A3XAI_spawnChanceMultiplier);
	if ((_trigger getVariable ["spawnChance",1]) call A3XAI_chance) then {
		_totalAI = ((_minAI + round(random _addAI)) min MAX_UNITS_PER_STATIC_SPAWN);
		_spawnPos = if ((count _locationArray) > 0) then {_locationArray call A3XAI_findSpawnPos} else {[(getPosATL _trigger),random (_patrolDist),random(360),0] call A3XAI_SHK_pos};
	};

	//If non-zero unit amount and valid spawn position, spawn group, otherwise add it to respawn queue.
	_unitGroup = grpNull;
	try {
		if ((_totalAI > 0) && {(count _spawnPos) > 1}) then {
			_unitGroup = [_totalAI,_unitGroup,"static",_spawnPos,_trigger,_unitLevel] call A3XAI_spawnGroup;
			if (isNull _unitGroup) then {
				throw format ["A3XAI Debug: No units spawned for static spawn at %1. Added group to respawn queue.",(triggerText _trigger)];
			};
			_totalSpawned = _totalSpawned + _totalAI;
			if (_patrolDist > 1) then {
				0 = [_unitGroup,_triggerPos,_patrolDist] spawn A3XAI_BIN_taskPatrol;
			} else {
				[_unitGroup, 0] setWaypointType "GUARD";
			};
			if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Spawned group %1 (unitLevel: %2) with %3 units.",_unitGroup,_unitLevel,_totalAI];};
		} else {
			throw format ["A3XAI Debug: No units spawned for static spawn at %1. Added group to respawn queue.",(triggerText _trigger)];
		};
	} catch {
		_unitGroup = ["static",true] call A3XAI_createGroup;
		_unitGroup setVariable ["GroupSize",0];
		_unitGroup setVariable ["trigger",_trigger];
		0 = [0,_trigger,_unitGroup] call A3XAI_addRespawnQueue;
		if (A3XAI_debugLevel > 1) then {diag_log _exception;};
	};
	_grpArray pushBack _unitGroup;
};

if (A3XAI_debugLevel > 0) then {
	diag_log format["A3XAI Debug: Spawned %1 new AI groups (%2 units total) in %3 seconds at %4.",_numGroups,_totalSpawned,(diag_tickTime - _startTime),(triggerText _trigger)];
	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Trigger %1 group array updated to: %2.",triggerText _trigger,_trigger getVariable "GroupArray"]};
};

true
