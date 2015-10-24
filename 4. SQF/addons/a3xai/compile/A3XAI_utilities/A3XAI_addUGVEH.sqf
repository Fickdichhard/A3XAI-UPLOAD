#include "\A3XAI\globaldefines.hpp"

if (isNull _this) exitWith {};

_this addEventHandler ["Killed","_this call A3XAI_UGV_destroyed"];
_this addEventHandler ["HandleDamage","_this call A3XAI_handleDamageUGV"];

if (A3XAI_detectOnlyUGVs) then {
	_this addEventHandler ["Hit","_this call A3XAI_defensiveAggression"];
};

true