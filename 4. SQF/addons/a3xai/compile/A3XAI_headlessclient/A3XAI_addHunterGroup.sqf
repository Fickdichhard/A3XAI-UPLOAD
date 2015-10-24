#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_targetPlayer"];

_unitGroup = _this select 0;
_targetPlayer = _this select 1;

_unitGroup setVariable ["targetPlayer",_targetPlayer];

true