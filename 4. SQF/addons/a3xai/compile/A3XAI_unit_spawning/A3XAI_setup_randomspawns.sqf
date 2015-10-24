#include "\A3XAI\globaldefines.hpp"

private ["_maxRandomSpawns","_attempts","_trigPos","_trigger","_markername","_marker"];

_maxRandomSpawns = _this;

if (isNil SERVER_STARTED_INDICATOR) then {
	private ["_expireTime"];
	_expireTime = diag_tickTime + SERVER_START_TIMEOUT;
	waitUntil {uiSleep 3; (!isNil SERVER_STARTED_INDICATOR) or {diag_tickTime > _expireTime}};
};

if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Attempting to place %1 random spawns on the map...",_maxRandomSpawns];};

for "_i" from 1 to _maxRandomSpawns do {
	_attempts = 0;
	_posCheckFail = true;
	_trigPos = [];
	while {
		(_posCheckFail && {_attempts < MAX_RANDOMSPAWN_RETRY_ATTEMPTS})
	} do {
		_attempts = _attempts + 1;
		_trigPos = if (_attempts < MAX_RANDOMSPAWN_RETRY_ATTEMPTS) then {
			_randomLocation = (A3XAI_locations call A3XAI_selectRandom) select 1;
			[_randomLocation,CREATE_RANDOM_SPAWN_DIST_BASE+(random CREATE_RANDOM_SPAWN_DIST_VARIANCE),(random 360),0] call A3XAI_SHK_pos
		} else {
			["A3XAI_centerMarker",0] call A3XAI_SHK_pos
		};
			
		_posCheckFail = (
			(({if (_trigPos in _x) exitWith {1}} count (nearestLocations [_trigPos,[BLACKLIST_OBJECT_GENERAL,BLACKLIST_OBJECT_RANDOM],1500])) > 0) ||	//Position not in blacklisted area
			{({if ((_trigPos distance2D _x) < (TRIGGER_SIZE_NORMAL_DOUBLED + A3XAI_distanceBetweenRandomSpawns)) exitWith {1}} count A3XAI_randTriggerArray) > 0} ||				//Not too close to another random spawn.
			{!((_trigPos nearObjects [PLOTPOLE_OBJECT,PLOTPOLE_RADIUS]) isEqualTo [])}																	//Position not blocked by a jammer
		);
		if (_posCheckFail && {_attempts < MAX_RANDOMSPAWN_RETRY_ATTEMPTS}) then {uiSleep 0.25};
	};
	
	if !(_posCheckFail) then {
		_spawnParams = _trigPos call A3XAI_getSpawnParams;
		_trigger = createTrigger [TRIGGER_OBJECT,_trigPos,false];
		_location = [_trigPos,TEMP_BLACKLIST_AREA_RANDOM_SIZE] call A3XAI_createBlackListAreaRandom;
		_trigger setVariable ["triggerLocation",_location];
		[_trigger,"A3XAI_randTriggerArray"] call A3XAI_updateSpawnCount;
		_onActStatements = format ["0 = [%1,thisTrigger,thisList,%2,%3,%4,%5] call A3XAI_createRandomInfantrySpawnQueue;",PATROL_DIST_RANDOM,_spawnParams select 0,_spawnParams select 1,_spawnParams select 2,_spawnParams select 3];
		_trigger setTriggerArea [TRIGGER_SIZE_SMALL,TRIGGER_SIZE_SMALL,0,false];
		_trigger setTriggerActivation ["ANY", "PRESENT", true];
		_trigger setTriggerTimeout [TRIGGER_TIMEOUT_RANDOM, true];
		_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;",_onActStatements,"[thisTrigger] spawn A3XAI_despawn_random;"];
		if (A3XAI_enableDebugMarkers) then {
			_markername = str(_trigger);
			_marker = createMarker[_markername,_trigPos];
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerType "Flag";
			_marker setMarkerBrush "SOLID";
			_marker setMarkerSize [600, 600];
			_marker setMarkerColor "ColorYellow";
			_marker setMarkerAlpha 0.6;
			A3XAI_mapMarkerArray set [(count A3XAI_mapMarkerArray),_marker];
		};
		_trigger setTriggerText format ["Random Spawn at %1",(mapGridPosition _trigger)];
		_trigger setVariable ["timestamp",diag_tickTime];
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Random spawn %1 of %2 placed at %3 with params %4 (Attempts: %5).",_i,_maxRandomSpawns,_trigPos,_spawnParams,_attempts];};
	} else {
		if (A3XAI_debugLevel > 0) then {diag_log format["A3XAI Debug: Could not find suitable location to place random spawn %1 of %2.",_i,_maxRandomSpawns];};
	};
	uiSleep 3;
};
