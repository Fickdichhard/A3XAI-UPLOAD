#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_position","_waypoint","_result"];
_unitGroup = _this select 0;
_position = _this select 1;
_result = false;

if !(surfaceIsWater _position) then {
	_waypoint = [_unitGroup,0];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointCompletionRadius 40;
	_waypoint setWaypointTimeout [3,4,5];
	_waypoint setWPPos _position;
	if (local _unitGroup) then {
		_unitGroup setCurrentWaypoint _waypoint;
	} else {
		A3XAI_setCurrentWaypoint_PVC = _waypoint;
		A3XAI_HCObjectOwnerID publicVariableClient "A3XAI_setCurrentWaypoint_PVC";
	};
	_result = true;
};

_result