#include "\A3XAI\globaldefines.hpp"

if ((typeName _this) isEqualTo "ARRAY") then {
	private ["_arraySize","_spawnName","_spawnPos","_patrolDist","_trigStatements","_trigger","_respawn","_unitLevel","_totalAI","_respawnTime"];
	
	_arraySize = (count _this);
	_spawnName = _this select 0;
	_spawnPos = _this select 1;
	_patrolDist = if (_arraySize> 2) then {_this select 2} else {100};
	_totalAI = if (_arraySize > 3) then {_this select 3} else {2};
	_unitLevel = if (_arraySize > 4) then {_this select 4} else {2};
	_respawn = if (_arraySize > 5) then {_this select 5} else {false};
	_respawnTime = if (_arraySize > 6) then {_this select 6} else {0};

	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Creating custom spawn area with params %1.",_this];};

	if !(_unitLevel in A3XAI_unitLevels) then {_unitLevel = 3;};

	if !(surfaceIsWater _spawnPos) then {
		_trigStatements = format ["0 = [%1,0,%2,thisTrigger,%3,%4] call A3XAI_createCustomInfantrySpawnQueue;",_totalAI,_patrolDist,_unitLevel,_respawnTime];
		_trigger = createTrigger [TRIGGER_OBJECT,_spawnPos,false];
		_trigger setTriggerArea [TRIGGER_SIZE_NORMAL,TRIGGER_SIZE_NORMAL,0,false];
		_trigger setTriggerActivation ["ANY", "PRESENT", true];
		_trigger setTriggerTimeout [TRIGGER_TIMEOUT_STATICCUSTOM, true];
		_trigger setTriggerText _spawnName;
		_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;",_trigStatements,"0 = [thisTrigger] spawn A3XAI_despawn_static;"];
		_trigger setVariable ["respawn",_respawn];
		//_trigger setVariable ["spawnmarker",_spawnName];
		_trigger setVariable ["isCustom",true];
		if (_respawnTime > 0) then {_trigger setVariable ["respawnTime",_respawnTime];};

		0 = [3,_trigger,[],_patrolDist,_unitLevel,[],[_totalAI,0]] call A3XAI_initializeTrigger;
		//diag_log format ["DEBUG: triggerstatements variable is %1",_trigger getVariable "triggerStatements"];
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Created custom spawn area %1 at %2 with %3 AI units, unitLevel %4, respawn %5, respawn time %6.",_spawnName,mapGridPosition _trigger,_totalAI,_unitLevel,_respawn,_respawnTime];};

		_trigger
	} else {
		diag_log format ["A3XAI Error: Unable to create custom spawn %1, position at %2 is water.",_spawnName,_spawnPos];
		objNull
	};
} else {
	diag_log format ["Error: Wrong arguments sent to %1 (%2).",__FILE__,_this];
	objNull
};
