#include "\A3XAI\globaldefines.hpp"

private ["_vehicle","_unitGroup","_unitsAlive"];

_vehicle = (_this select 0);

if (isNull _vehicle) exitWith {};
if (_vehicle getVariable ["vehicle_disabled",false]) exitWith {};
_vehicle setVariable ["vehicle_disabled",true];
{_vehicle removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed","Hit","Hit"];
_unitGroup = _vehicle getVariable ["unitGroup",grpNull];
_vehicle call A3XAI_respawnAIVehicle;
if !(isNil {_unitGroup getVariable "dummyUnit"}) exitWith {};

_unitGroup setVariable ["GroupSize",-1];
if !(isDedicated) then {
	A3XAI_updateGroupSize_PVS = [_unitGroup,-1];
	publicVariableServer "A3XAI_updateGroupSize_PVS";
};

if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Group %1 %2 destroyed at %3",_unitGroup,(typeOf _vehicle),mapGridPosition _vehicle];};
