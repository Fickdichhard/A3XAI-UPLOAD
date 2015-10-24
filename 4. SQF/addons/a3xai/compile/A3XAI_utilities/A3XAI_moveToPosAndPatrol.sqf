#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_currentWaypoint","_radius"];

_unitGroup = _this select 0;
_radius = _this select 1;

_currentWaypoint = (currentWaypoint _unitGroup);
_pos = (waypointPosition _currentWaypoint);
deleteWaypoint [_unitGroup,_currentWaypoint]; 
[_unitGroup,"Behavior_Reset"] call A3XAI_forceBehavior;
0 = [_unitGroup,_pos,_radius] spawn A3XAI_BIN_taskPatrol;

true