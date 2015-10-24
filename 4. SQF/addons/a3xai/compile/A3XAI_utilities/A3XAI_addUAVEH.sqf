#include "\A3XAI\globaldefines.hpp"

if (isNull _this) exitWith {};

_this addEventHandler ["Killed","_this call A3XAI_UAV_destroyed"];

if (A3XAI_detectOnlyUAVs) then {
	_this addEventHandler ["Hit","_this call A3XAI_defensiveAggression"];
};

true