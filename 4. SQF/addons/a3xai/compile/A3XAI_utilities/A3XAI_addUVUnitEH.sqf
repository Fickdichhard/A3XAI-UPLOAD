#include "\A3XAI\globaldefines.hpp"

if (isNull _this) exitWith {};

_this addEventHandler ["Killed","_this call A3XAI_handle_death_UV;"];

true