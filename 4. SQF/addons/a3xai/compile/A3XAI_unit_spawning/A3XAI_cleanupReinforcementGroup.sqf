#include "\A3XAI\globaldefines.hpp"

_unitGroup = _this;

if (!((typeName _unitGroup) isEqualTo "GROUP") || {isNull _unitGroup}) exitWith {diag_log format ["A3XAI Error: Invalid group %1 provided to %2.",_unitGroup,__FILE__];};

diag_log format ["Debug: Cleaning up reinforcement group %1.",_unitGroup];
_vehicle = _unitGroup getVariable ["assignedVehicle",objNull];
_vehicle allowDamage false;
_vehicle enableSimulationGlobal false;
_vehicle hideObjectGlobal true;
{_vehicle removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed","Hit"];
{_x enableSimulationGlobal false;} forEach (units _unitGroup);
_unitGroup setVariable ["GroupSize",-1];
if (A3XAI_HCIsConnected) then {
	A3XAI_cleanupReinforcement_PVC = [_unitGroup,_vehicle];
	A3XAI_HCObjectOwnerID publicVariableClient "A3XAI_cleanupReinforcement_PVC";
};

true
