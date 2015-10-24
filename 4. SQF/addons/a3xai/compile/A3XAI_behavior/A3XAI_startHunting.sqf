#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_triggerPos", "_targetPlayer", "_nearbyUnits", "_waypoint", "_patrolDist","_targetPos"];

_unitGroup = _this select 0;
_patrolDist = _this select 1;
_targetPlayer = _this select 2;
_triggerPos = _this select 3;

_targetPos = getPosATL _targetPlayer;
if ((isPlayer _targetPlayer) && {(vehicle _targetPlayer) isKindOf "Land"}) then {
	if (A3XAI_enableRadioMessages) then {
		//diag_log "DEBUG: Sending radio static";
		if ((_unitGroup getVariable ["GroupSize",0]) > 0) then {
			_nearbyUnits = _targetPlayer nearEntities [["LandVehicle",PLAYER_UNITS],TRANSMIT_RANGE_RADIO_HUNTKILLER];
			if ((count _nearbyUnits) > 10) then {_nearbyUnits resize 10;};
			{
				if (isPlayer _x) then {
					if (({if (RADIO_ITEM in (assignedItems _x)) exitWith {1}} count (units (group _x))) > 0) then {
						[_x,[0,[]]] call A3XAI_radioSend;
					};
				}
			} count _nearbyUnits;
		};
	};
	
	_unitGroup setSpeedMode "FULL";

	_waypoint = [_unitGroup,0];	//Group will move to waypoint index 0 (first waypoint).
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointCompletionRadius 50;
	_waypoint setWaypointTimeout [3, 3, 3];
	_waypoint setWPPos _targetPos;
	_waypoint setWaypointStatements ["true","if !(local this) exitWith {}; (group this) spawn A3XAI_hunterLocate;"];
	
	_unitGroup setCurrentWaypoint _waypoint;
	
	_unitGroup setVariable ["targetplayer",_targetPlayer];
	if (A3XAI_enableHC && {"dynamic" in A3XAI_HCAllowedTypes}) then {
		_unitGroup setVariable ["HC_Ready",true];
		_unitGroup setVariable ["MiscData",_targetPlayer];
	};
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Dynamic group %1 is now hunting player %2.",_unitGroup,_targetPlayer];};
} else {
	0 = [_unitGroup,_triggerPos,_patrolDist] spawn A3XAI_BIN_taskPatrol;
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Dynamic group %1 is patrolling area.",_unitGroup];};
};
