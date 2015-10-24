#include "\A3XAI\globaldefines.hpp"

private ["_comparePos"];
_begin = _this select 0;
_end = _this select 1;
_ignore = _this select 2;

!(lineIntersects [_begin,_end,_ignore])