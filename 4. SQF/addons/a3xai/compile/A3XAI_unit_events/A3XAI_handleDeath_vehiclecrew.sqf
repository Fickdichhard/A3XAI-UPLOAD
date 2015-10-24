#include "A3XAI_handleDeath_static.sqf"
/*
private ["_vehicle"];

_vehicle = _unitGroup getVariable ["assignedVehicle",objNull];
if (isNull _vehicle) exitWith {diag_log format ["A3XAI Debug: Group %1 has no assigned vehicle.",_unitGroup];};

if ((alive _vehicle) && {A3XAI_vehiclesAllowedForPlayers}) then {
	_vehicle call A3XAI_releaseVehicleAllow;
	if !(isDedicated) then {
		A3XAI_requestVehicleRelease_PVS = _vehicle;
		publicVariableServer "A3XAI_requestVehicleRelease_PVS";
	};
};

true
*/
