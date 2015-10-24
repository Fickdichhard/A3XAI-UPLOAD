#include "\A3XAI\globaldefines.hpp"

private ["_unit","_unitPos","_parachute"];

_unit = _this;

_unitPos = getPosATL _unit;
_parachute = createVehicle [PARACHUTE_OBJECT, _unitPos, [], (-10 + (random 10)), "FLY"];
unassignVehicle _unit;
_unit setPosATL _unitPos;
_unit moveInDriver _parachute;

_parachute
