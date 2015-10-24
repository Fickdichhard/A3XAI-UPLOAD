#include "\A3XAI\globaldefines.hpp"

if (isNull _this) exitWith {};

if (isNil {_this getVariable "durability"}) then {_this setVariable ["durability",[0,0,0,0]];};
_this addEventHandler ["Killed","_this call A3XAI_heliDestroyed"];
_this addEventHandler ["GetOut","_this call A3XAI_heliLanded"];
_this addEventHandler ["HandleDamage","_this call A3XAI_handleDamageHeli"];

true