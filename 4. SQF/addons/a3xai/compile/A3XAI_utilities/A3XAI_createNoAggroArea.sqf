#include "\A3XAI\globaldefines.hpp"

private ["_pos","_size","_location"];

_pos = _this select 0;
_size = _this select 1;

_location = createLocation [BLACKLIST_OBJECT_NOAGGRO,_pos,_size,_size];
A3XAI_noAggroAreas pushBack _location;

_location
