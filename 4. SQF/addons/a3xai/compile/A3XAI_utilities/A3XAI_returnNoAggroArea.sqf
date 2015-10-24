#include "\A3XAI\globaldefines.hpp"

private ["_noAggroArea", "_objectPos"];

_objectPos = _this;

_noAggroArea = locationNull;
if ((typeName _this) isEqualTo "OBJECT") then {_objectPos = getPosATL _this};

{
	if (_objectPos in _x) exitWith {
		_noAggroArea = _x;
	};
} forEach A3XAI_noAggroAreas;

_noAggroArea
