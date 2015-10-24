#include "\A3XAI\globaldefines.hpp"

private ["_inNoAggroArea", "_objectPos", "_noAggroRange"];

_objectPos = _this select 0;
_noAggroRange = [_this,1,900] call A3XAI_param;

if (_objectPos isEqualTo objNull) exitWith {false};
if ((typeName _objectPos) isEqualTo "OBJECT") then {_objectPos = getPosATL _objectPos};

_inNoAggroArea = false;
{
	if (((position _x) distance2D _objectPos) < _noAggroRange) exitWith {
		_inNoAggroArea = true;
	};
} count A3XAI_noAggroAreas;

_inNoAggroArea
