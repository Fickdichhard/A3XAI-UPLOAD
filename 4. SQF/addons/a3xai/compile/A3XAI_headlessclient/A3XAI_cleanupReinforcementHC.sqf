#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_vehicle"];

_unitGroup = _this select 0;
_vehicle = _this select 1;

{_vehicle removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed","Hit"];
_unitGroup setVariable ["GroupSize",-1];

if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Releasing ownership of reinforcement group %1 to server.",_unitGroup];};

true
