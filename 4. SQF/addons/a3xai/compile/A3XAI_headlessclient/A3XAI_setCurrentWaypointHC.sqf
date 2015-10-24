private ["_unitGroup","_waypointIndex"];
_unitGroup = _this select 0;
_waypointIndex = _this select 1;
_unitGroup setCurrentWaypoint [_unitGroup,_waypointIndex];
true