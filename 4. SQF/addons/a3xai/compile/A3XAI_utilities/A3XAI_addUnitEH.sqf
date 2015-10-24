#include "\A3XAI\globaldefines.hpp"

if (isNull _this) exitWith {};

_this addEventHandler ["Killed","_this call A3XAI_handleDeathEvent;"];
_this addEventHandler ["HandleDamage","_this call A3XAI_handleDamageUnit;"];

_this setVariable ["bodyName",(name _this)];

true