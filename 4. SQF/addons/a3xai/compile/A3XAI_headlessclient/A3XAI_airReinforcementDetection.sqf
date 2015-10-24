#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_unitLevel", "_unitType", "_groupSize", "_vehicle"];

_unitGroup = _this select 0;
_vehicle = _this select 1;

if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Waiting for reinforcement group %1 ready state.",_unitGroup];};
waitUntil {uiSleep 10; diag_log format ["Debug: Group %1 behavior is %2, combat mode %3.",_unitGroup,(behaviour (leader _unitGroup)),(combatMode _unitGroup)]; !((behaviour (leader _unitGroup)) isEqualTo "CARELESS")};
if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Group %1 has now entered ready state.",_unitGroup];};

while {((behaviour (leader _unitGroup)) in ["AWARE","COMBAT"]) && {(_unitGroup getVariable ["GroupSize",-1]) > 0}} do {
	if (local _unitGroup) then {
		_vehiclePos = getPosATL _vehicle;
		_vehiclePos set [2,0];
		_nearUnits = _vehiclePos nearEntities [[PLAYER_UNITS,"LandVehicle"],250];
		if ((count _nearUnits) > 5) then {_nearUnits resize 5};
		{
			if ((isPlayer _x) && {(_unitGroup knowsAbout _x) < 3}) then {
				_unitGroup reveal [_x,3];
				if (({if (RADIO_ITEM in (assignedItems _x)) exitWith {1}} count (units (group _x))) > 0) then {
					[_x,[31+(floor (random 5)),[name (leader _unitGroup)]]] call A3XAI_radioSend;
				};
			};
		} forEach _nearUnits;
	};
	uiSleep 15;
};
