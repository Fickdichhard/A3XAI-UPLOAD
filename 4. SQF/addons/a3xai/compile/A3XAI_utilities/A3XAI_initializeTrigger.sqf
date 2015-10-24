#include "\A3XAI\globaldefines.hpp"

private["_trigger","_mode"];

_mode = _this select 0;
_trigger = _this select 1;

_trigger setVariable ["isCleaning",false];
_trigger setVariable ["GroupArray",(_this select 2)];

call {
	if (_mode isEqualTo 0) exitWith {
		//Static spawns
		_trigger setVariable ["patrolDist",(_this select 3)];
		_trigger setVariable ["unitLevel",(_this select 4)];
		_trigger setVariable ["unitLevelEffective",(_this select 4)];
		_trigger setVariable ["locationArray",(_this select 5)];
		_trigger setVariable ["maxUnits",(_this select 6)];
		_trigger setVariable ["spawnChance",(_this select 7)];
		_trigger setVariable ["spawnType","static"];
		if (A3XAI_debugLevel > 1) then {diag_log format["A3XAI Debug: Initialized static spawn at %1 (%2). GroupArray: %3, PatrolDist: %4. unitLevel: %5. %LocationArray %6 positions, MaxUnits %7, SpawnChance %8.",(triggerText _trigger),(getPosATL _trigger),(_this select 2),(_this select 3),(_this select 4),count (_this select 5),(_this select 6),(_this select 7)];};
	};
	if (_mode isEqualTo 1) exitWith {
		//Dynamic spawns
		_trigger setVariable ["spawnType","dynamic"];
		if (A3XAI_debugLevel > 1) then {diag_log format["A3XAI Debug: Initialized dynamic spawn at %1. GroupArray: %2.",triggerText _trigger,(_this select 2)];};
	};
	if (_mode isEqualTo 2) exitWith {
		//Random spawns
		_trigger setVariable ["spawnType","random"];
		if (A3XAI_debugLevel > 1) then {diag_log format["A3XAI Debug: Initialized random spawn at %1. GroupArray: %2.",triggerText _trigger,(_this select 2)];};
	};
	if (_mode isEqualTo 3) exitWith {
		//Static spawns (custom)
		_trigger setVariable ["patrolDist",(_this select 3)];
		_trigger setVariable ["unitLevel",(_this select 4)];
		_trigger setVariable ["unitLevelEffective",(_this select 4)];
		_trigger setVariable ["locationArray",(_this select 5)];
		_trigger setVariable ["maxUnits",(_this select 6)];
		_trigger setVariable ["spawnChance",1];
		_trigger setVariable ["spawnType","staticcustom"];
		if (A3XAI_debugLevel > 1) then {diag_log format["A3XAI Debug: Initialized custom spawn at %1. GroupArray: %2, PatrolDist: %3. unitLevel: %4. %LocationArray %5 positions, MaxUnits %6.",triggerText _trigger,(_this select 2),(_this select 3),(_this select 4),count (_this select 5),(_this select 6)];};
	};
	if (_mode isEqualTo 4) exitWith {
		//Vehicle group
		_trigger setVariable ["patrolDist",(_this select 3)];
		_trigger setVariable ["unitLevel",(_this select 4)];
		_trigger setVariable ["maxUnits",(_this select 5)];
		_trigger setVariable ["spawnChance",1];
		_trigger setVariable ["spawnType","vehiclecrew"];
		_trigger setVariable ["respawn",false]; 					
		_trigger setVariable ["permadelete",true];
		if (A3XAI_debugLevel > 1) then {diag_log format["A3XAI Debug: Initialized vehicle group at %1. GroupArray: %2, PatrolDist: %3. unitLevel: %4, MaxUnits %5.",triggerText _trigger,(_this select 2),(_this select 3),(_this select 4),(_this select 5)];};
	};
	if (_mode isEqualTo 5) exitWith {
		//Paradrop group
		_trigger setVariable ["patrolDist",(_this select 3)];
		_trigger setVariable ["unitLevel",(_this select 4)];
		_trigger setVariable ["maxUnits",(_this select 5)];
		_trigger setVariable ["spawnChance",1];
		_trigger setVariable ["spawnType","vehiclecrew"];
		_trigger setVariable ["respawn",false]; 					
		_trigger setVariable ["permadelete",true];
		if (A3XAI_debugLevel > 1) then {diag_log format["A3XAI Debug: Initialized paradrop group at %1. GroupArray: %2, PatrolDist: %3. unitLevel: %4, MaxUnits %5.",triggerText _trigger,(_this select 2),(_this select 3),(_this select 4),(_this select 5)];};
	};
};

_trigger setVariable ["triggerStatements",+(triggerStatements _trigger)];
_trigger setVariable ["initialized",true];

true
