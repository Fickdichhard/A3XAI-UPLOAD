#include "\A3XAI\globaldefines.hpp"

if (isNull _this) exitWith {};

_this addEventHandler ["Killed","_this call A3XAI_vehDestroyed"];
_this addEventHandler ["HandleDamage","_this call A3XAI_handleDamageVeh"];

true