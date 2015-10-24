#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_waypoint","_pos","_wpStatements"];

_unitGroup = _this select 0;
_pos = _this select 1;
_wpStatements = if ((count _this) > 2) then {_this select 2} else {"if !(local this) exitWith {}; (group this) call A3XAI_moveToPosAndDeleteWP;"};

if !(_pos isEqualTo [0,0,0]) then {
	_waypoint = _unitGroup addWaypoint [_pos,0];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointCompletionRadius 30;
	_waypoint setWaypointStatements ["true",_wpStatements];

	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Group %1 assigned temporary waypoint at %2 with statements %3.",_unitGroup,_pos,_wpStatements];};

	_waypoint
} else {
	diag_log format ["A3XAI Error: Group %1 was assigned temporary waypoint at %2.",_unitGroup,_pos];
};
