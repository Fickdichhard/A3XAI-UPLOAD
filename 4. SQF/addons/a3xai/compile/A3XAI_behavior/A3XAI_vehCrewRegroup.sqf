#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_vehicle","_loadWP","_loadWPCond","_unit","_regroupPos","_waypointCycle"];

_unitGroup = _this select 0;
_vehicle = _this select 1;

if ((count (waypoints _unitGroup)) > 1) exitWith {
	if (isNull (driver _vehicle)) then {
		[_unitGroup,1] setWaypointPosition [(getPosATL _vehicle),0];
		_unitGroup setCurrentWaypoint [_unitGroup,1];
	};
};

_unit = objNull;
{
	if (isNull (objectParent _x)) exitWith {_unit = _x};
} forEach (units _unitGroup);

if (isNull _unit) exitWith {_unitGroup call A3XAI_setVehicleRegrouped}; //If no units outside of vehicle, consider crew regrouped and exit script

_regroupPos = if (isNull (driver _vehicle)) then {
	(getPosATL _vehicle)
} else {
	([_vehicle,_unit,(_unit distance _vehicle)/2] call A3XAI_getPosBetween)
};

_loadWP = _unitGroup addWaypoint [_regroupPos,0];
_loadWP setWaypointType "LOAD";
_loadWPCond = "_vehicle = (group this) getVariable ['assignedVehicle',objNull]; ({_x isEqualTo (vehicle _x)} count (assignedCargo _vehicle)) isEqualTo 0";
_loadWP setWaypointStatements [_loadWPCond,"if !(local this) exitWith {}; (group this) spawn A3XAI_vehCrewRegroupComplete;"];

_waypointCycle = _unitGroup addWaypoint [_regroupPos, 0];
_waypointCycle setWaypointType "CYCLE";
_waypointCycle setWaypointStatements ["true","if !(local this) exitWith {}; _unitGroup = (group this); deleteWaypoint [_unitGroup,2]; deleteWaypoint [_unitGroup,1];"];
_waypointCycle setWaypointCompletionRadius 150;

_loadWP setWaypointCompletionRadius 10;
_unitGroup setCurrentWaypoint _loadWP;

if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Regroup order issued for AI group %1 to vehicle %2. Check WP count: %3.",_unitGroup,typeOf _vehicle,(count (waypoints _unitGroup))];};

true
