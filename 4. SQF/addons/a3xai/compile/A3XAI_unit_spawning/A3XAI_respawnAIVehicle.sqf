#include "\A3XAI\globaldefines.hpp"

private ["_vehicle", "_vehicleType", "_spawnParams"];

_vehicle = _this;
if (isNull _vehicle) exitWith {diag_log format ["Error: %1 attempted to respawn null vehicle",__FILE__];};

if (isDedicated) then {
	_vehicleType = (typeOf _vehicle);
	_spawnParams = _vehicle getVariable ["spawnParams",[]];
	_vehicleClass = [configFile >> "CfgVehicles" >> _vehicleType,"vehicleClass",""] call BIS_fnc_returnConfigEntry;
	if !((toLower _vehicleClass) isEqualTo "autonomous") then {
		if (_spawnParams isEqualTo []) then {
			[2,_vehicleType] call A3XAI_addRespawnQueue;
		} else {
			if (_spawnParams select 4) then {
				[1,_spawnParams] call A3XAI_addRespawnQueue;
			};
		};
		if (_vehicleType isKindOf "Air") then {A3XAI_curHeliPatrols = A3XAI_curHeliPatrols - 1} else {A3XAI_curLandPatrols = A3XAI_curLandPatrols - 1};
	} else {
		[3,_vehicleType] call A3XAI_addRespawnQueue;
		if (_vehicleType isKindOf "Air") then {A3XAI_curUAVPatrols = A3XAI_curUAVPatrols - 1} else {A3XAI_curUGVPatrols = A3XAI_curUGVPatrols - 1};
	};
	_vehicle setVariable ["A3XAI_deathTime",diag_tickTime]; //mark vehicle for cleanup
} else {
	A3XAI_respawnVehicle_PVS = _vehicle;
	publicVariableServer "A3XAI_respawnVehicle_PVS";
};

if ((alive _vehicle) && {A3XAI_vehiclesAllowedForPlayers}) then {
	_vehicle call A3XAI_releaseVehicleAllow;
} else {
	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Respawning AI %1.",(typeOf _vehicle)]};
};

{_vehicle removeAllEventHandlers _x} count ["HandleDamage","Killed","GetOut","Local","Hit"];

true
