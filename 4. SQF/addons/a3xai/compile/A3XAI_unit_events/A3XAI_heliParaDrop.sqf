#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_vehicle", "_targetPlayer", "_cargoAvailable", "_vehiclePos"];

_unitGroup = _this select 0;
_vehicle = _this select 1;
_targetPlayer = _this select 2;

_vehiclePos = getPosATL _vehicle;
if (surfaceIsWater _vehiclePos) exitWith {};
_cargoAvailable = (_vehicle emptyPositions "cargo") min A3XAI_paraDropAmount;
if (_cargoAvailable > 0) then {
	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: %1 group %2 has enough cargo positions for successful paradrop. Spawning new group.",typeOf _vehicle,_unitGroup];};
	
	_nul = _vehicle spawn {
		_this allowDamage false;
		uiSleep 5;
		_this allowDamage true;
	};
	
	if (isDedicated) then {
		[_vehicle,_unitGroup,_cargoAvailable,_targetPlayer] call A3XAI_addParaGroup;
	} else {
		A3XAI_addParaGroup_PVS = [_vehicle,_unitGroup,_cargoAvailable,_targetPlayer];
		publicVariableServer "A3XAI_addParaGroup_PVS";
	};
};
