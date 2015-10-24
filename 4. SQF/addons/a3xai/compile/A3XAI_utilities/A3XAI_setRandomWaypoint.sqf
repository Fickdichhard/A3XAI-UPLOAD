#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_currentWaypoint", "_allWaypoints", "_selectedWaypoint"];

_unitGroup = _this select 0;
_currentWaypoint = (currentWaypoint _unitGroup);
_allWaypoints = (waypoints _unitGroup) - [_unitGroup,_currentWaypoint];
_selectedWaypoint = _allWaypoints call A3XAI_selectRandom;
_unitGroup setCurrentWaypoint _selectedWaypoint;

_selectedWaypoint
