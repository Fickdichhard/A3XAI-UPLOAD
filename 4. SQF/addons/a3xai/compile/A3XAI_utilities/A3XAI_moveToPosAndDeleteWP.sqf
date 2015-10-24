#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup"];

_unitGroup = _this; 
deleteWaypoint [_unitGroup,(currentWaypoint _unitGroup)]; 
_unitGroup setCurrentWaypoint ((waypoints _unitGroup) call BIS_fnc_selectRandom);

true