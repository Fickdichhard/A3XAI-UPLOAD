#include "\A3XAI\globaldefines.hpp"

private ["_vehicle","_unitGroup","_unitLevel"];

_vehicle = (_this select 0);
_unitGroup = _vehicle getVariable ["unitGroup",grpNull];

if (_vehicle getVariable ["vehicle_disabled",false]) exitWith {};

{_vehicle removeAllEventHandlers _x} count ["HandleDamage","GetIn","GetOut","Killed","Hit"];
_vehicle setVariable ["vehicle_disabled",true];
if !((_unitGroup getVariable ["unitType",""]) isEqualTo "air_reinforce") then {_vehicle call A3XAI_respawnAIVehicle;};
if !(isNil {_unitGroup getVariable "dummyUnit"}) exitWith {};

if !(surfaceIsWater (getPosASL _vehicle)) then {
	_unitLevel = _unitGroup getVariable ["unitLevel",1];
	_unitGroup setVariable ["unitType","aircrashed"];	//Recategorize group as "aircrashed" to prevent AI inventory from being cleared since death is considered suicide.
	{
		if (alive _x) then {
			//_x action ["eject",_vehicle];
			_x call A3XAI_ejectParachute;
			_nul = [_x,objNull] call A3XAI_handleDeathEvent;
			0 = [_x,_unitLevel] spawn A3XAI_generateLootOnDeath;
		};
	} count (units _unitGroup);
};

_unitGroup setVariable ["GroupSize",-1];
if !(isDedicated) then {
	A3XAI_updateGroupSize_PVS = [_unitGroup,-1];
	publicVariableServer "A3XAI_updateGroupSize_PVS";
};

if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Group %1 %2 destroyed at %3",_unitGroup,(typeOf _vehicle),mapGridPosition _vehicle];};
true
