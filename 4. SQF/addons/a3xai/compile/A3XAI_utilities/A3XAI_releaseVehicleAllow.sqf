#include "\A3XAI\globaldefines.hpp"

private ["_object","_vehicleClass"];

_object = _this;

_vehicleClass = [configFile >> "CfgVehicles" >> (typeOf _object),"vehicleClass",""] call BIS_fnc_returnConfigEntry;
if ((toLower _vehicleClass) isEqualTo "autonomous") exitWith {};
	
_object removeAllEventHandlers "GetIn";
if (isDedicated) then {
	_object addEventHandler ["GetIn",{
		if (isPlayer (_this select 2)) then {
			(_this select 0) call A3XAI_releaseVehicleNow;
		};
	}];
};

if (local _object) then {
	_object lock 1;
	_object enableCopilot true;
	_object enableRopeAttach true;
	_object setFuel (random 1);

	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Released AI vehicle %1 at %2 for player access.",(typeOf _object),(getPosATL _object)];};	
} else {
	if (isDedicated && {(owner _object) isEqualTo A3XAI_HCObjectOwnerID}) then {
		A3XAI_requestVehicleRelease_PVC = _object;
		A3XAI_HCObjectOwnerID publicVariableClient "A3XAI_requestVehicleRelease_PVC";
	} else {
		diag_log format ["A3XAI Error: AI vehicle %1 is remote object but not owned by HC (OwnerID: %2, HC ID: %3).",_object,(owner _object),A3XAI_HCObjectOwnerID];
	};
};

true
