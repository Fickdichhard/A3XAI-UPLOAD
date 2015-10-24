#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_groupSize"];

_unitGroup = _this select 0;
_groupSize = _this select 1;

_unitGroup setVariable ["GroupSize",_groupSize];

true