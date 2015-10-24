#include "\A3XAI\globaldefines.hpp"

private ["_arrayData", "_unitGroup", "_trigger"];
_arrayData = _this;
_unitGroup = _arrayData select 0;

/*
if !(local _unitGroup) then {
	diag_log format ["Debug: Server sent group trigger variables for remote group %1.",_unitGroup];
};
*/

_trigger = _unitGroup getVariable "trigger";

if (isNil "_trigger") exitWith {diag_log format ["A3XAI Error: Group %1 has undefined trigger.",_unitGroup];};

//Remove array headers (Group reference)
_arrayData deleteAt 0;

{
	_trigger setVariable [_x,_arrayData select _forEachIndex];
	//diag_log format ["Debug: Group %1 variable %2 has value %3.",_unitGroup,_x,_arrayData select _forEachIndex];
} forEach [
	"GroupArray",
	"patrolDist",
	"unitLevel",
	"unitLevelEffective",
	"maxUnits",
	"spawnChance",
	"spawnType",
	"respawn",
	"permadelete"
];

if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Set group trigger variables for group %1. Success check: %2.",_unitGroup,_trigger isKindOf TRIGGER_OBJECT];};
