#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_vehicle","_vehiclePos"];

_unitGroup = _this;

_vehicle = _unitGroup getVariable ["assignedVehicle",objNull];
if (isNull _vehicle) exitWith {diag_log format ["A3XAI Error: Group %1 has null vehicle.",_unitGroup];};
_vehiclePos = getPosATL _vehicle;
[_unitGroup,0] setWaypointPosition [_vehiclePos,0];
[_unitGroup,2] setWaypointPosition [_vehiclePos,0];
_unitGroup call A3XAI_setVehicleRegrouped;

if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Regroup completed for vehicle group %1.",_unitGroup];};

true
