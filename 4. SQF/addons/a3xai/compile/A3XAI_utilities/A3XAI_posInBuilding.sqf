#include "\A3XAI\globaldefines.hpp"

private ["_comparePos"];
if ((count _this) isEqualTo 2) then {_this set [2,0]};
_comparePos = [(_this select 0),(_this select 1),(_this select 2) + 20];

(lineIntersects[_this, _comparePos])