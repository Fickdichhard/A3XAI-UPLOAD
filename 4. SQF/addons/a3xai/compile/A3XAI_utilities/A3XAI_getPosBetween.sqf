#include "\A3XAI\globaldefines.hpp"

private ["_pos1", "_pos2", "_direction", "_posBetween", "_distance"];

_pos1 = _this select 0;
_pos2 = _this select 1;
_distance = _this select 2;

if ((typeName _pos1) isEqualTo "OBJECT") then {_pos1 = getPosATL _pos1};
if ((typeName _pos2) isEqualTo "OBJECT") then {_pos2 = getPosATL _pos2};

_direction = [_pos1,_pos2] call BIS_fnc_dirTo;
_posBetween = [_pos1, _distance, _direction] call BIS_fnc_relPos;

_posBetween