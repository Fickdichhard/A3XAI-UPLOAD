#include "\A3XAI\globaldefines.hpp"

private ["_object"];

_object = _this;

_object addEventHandler ["GetIn",{
	if (isPlayer (_this select 2)) then {
		(_this select 2) action ["getOut",(_this select 0)];
		if ((_this select 0) getVariable ["vehicle_disabled",false]) then {deleteVehicle (_this select 0);};
	};
}];

_object setVehicleLock "LOCKEDPLAYER";
_object enableCopilot false;
_object enableRopeAttach false;

true
