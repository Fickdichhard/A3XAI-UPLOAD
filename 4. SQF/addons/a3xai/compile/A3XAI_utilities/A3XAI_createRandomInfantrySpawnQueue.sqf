#include "\A3XAI\globaldefines.hpp"

private ["_trigger", "_infantryQueue","_triggerStatements"];
if !((typeName _this) isEqualTo "ARRAY") exitWith {diag_log format ["Error: Wrong arguments sent to %1.",__FILE__]};

_trigger = _this select 1;
//diag_log format ["DEBUG: Started random spawn queue with args %1",_this];

if ((_trigger getVariable ["GroupArray",[]]) isEqualTo []) then {
	if (A3XAI_randomInfantrySpawnQueue isEqualTo []) then {
		A3XAI_randomInfantrySpawnQueue pushBack _this;
		_infantryQueue = [] spawn {
			while {!(A3XAI_randomInfantrySpawnQueue isEqualTo [])} do {
				private ["_args","_trigger"];
				_args = (A3XAI_randomInfantrySpawnQueue select 0);
				_trigger = _args select 1;
				if (triggerActivated _trigger) then {
					_trigger setVariable ["isCleaning",false];
					_triggerStatements = (triggerStatements _trigger);
					_triggerStatements set [1,""];
					_trigger setTriggerStatements _triggerStatements;
					0 = _args call A3XAI_spawnUnits_random;
					if (A3XAI_enableDebugMarkers) then {
						_marker = str(_trigger);
						_marker setMarkerColor "ColorOrange";
						_marker setMarkerAlpha 0.9;
					};
					uiSleep 3;
				};
				A3XAI_randomInfantrySpawnQueue deleteAt 0;
			};
		};
	} else {
		A3XAI_randomInfantrySpawnQueue pushBack _this;
	};
};

true