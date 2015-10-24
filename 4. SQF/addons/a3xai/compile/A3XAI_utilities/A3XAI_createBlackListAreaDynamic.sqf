#include "\A3XAI\globaldefines.hpp"

private ["_pos","_size"];

_pos = _this select 0;
_size = _this select 1;

createLocation [BLACKLIST_OBJECT_DYNAMIC,_pos,_size,_size]	