#include "\A3XAI\globaldefines.hpp"

private ["_trigger", "_grpArray", "_numGroups", "_infantryQueue","_triggerStatements"];
if !((typeName _this) isEqualTo "ARRAY") exitWith {diag_log format ["Error: Wrong arguments sent to %1.",__FILE__]};

_trigger = _this select 3;
_grpArray = _trigger getVariable ["GroupArray",[]];	
_numGroups = if ((count _this) > 6) then {_this select 6} else {1};

if ((count _grpArray) < _numGroups) then {
	if (A3XAI_staticInfantrySpawnQueue isEqualTo []) then {
		A3XAI_staticInfantrySpawnQueue pushBack _this;
		_infantryQueue = [] spawn {
			while {!(A3XAI_staticInfantrySpawnQueue isEqualTo [])} do {
				private ["_args","_trigger"];
				_args = (A3XAI_staticInfantrySpawnQueue select 0);
				_trigger = _args select 3;
				if (triggerActivated _trigger) then {
					_trigger setVariable ["isCleaning",false];
					_triggerStatements = (triggerStatements _trigger);
					_triggerStatements set [1,""];
					_trigger setTriggerStatements _triggerStatements;
					[_trigger,"A3XAI_staticTriggerArray"] call A3XAI_updateSpawnCount;
					0 = _args call A3XAI_spawnUnits_static;
					if (A3XAI_enableDebugMarkers) then {_nul = _trigger call A3XAI_addMapMarker;};
					uiSleep 3;
				};
				A3XAI_staticInfantrySpawnQueue deleteAt 0;
			};
		};
	} else {
		A3XAI_staticInfantrySpawnQueue pushBack _this;
	};
} else {
	private ["_triggerStatements"];
	_triggerStatements = (triggerStatements _trigger);
	_triggerStatements set [1,""];
	_trigger setTriggerStatements _triggerStatements;
	_trigger setTriggerArea [TRIGGER_SIZE_EXPANDED,TRIGGER_SIZE_EXPANDED,0,false];
	[_trigger,"A3XAI_staticTriggerArray"] call A3XAI_updateSpawnCount;
	if (A3XAI_enableDebugMarkers) then {
		_nul = _trigger call A3XAI_addMapMarker;
	};
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Maximum number of groups already spawned at %1. Exiting spawn script.",(triggerText _trigger)];};
};

true