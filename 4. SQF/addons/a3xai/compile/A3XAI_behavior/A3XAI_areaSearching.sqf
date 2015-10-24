#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_searchPoints", "_trigger", "_radius", "_posBetween", "_searchType", "_objects", "_waypoint"];

_unitGroup = _this select 0;

if ((count (waypoints _unitGroup)) > 9) exitWith {};

_searchPoints = call {
	_trigger = _unitGroup getVariable "trigger";
	if (isNil "_trigger") exitWith {[]};
	_radius = (_trigger getVariable ["patrolDist",100])/2;
	_posBetween = [_trigger,(leader _unitGroup),_radius] call A3XAI_getPosBetween;
	_searchType = floor (random 2);
	if (_searchType isEqualTo 0) exitWith {
		_objects = _posBetween nearObjects [LOOT_HOLDER_CLASS,_radius];
		_objects
	};
	if (_searchType isEqualTo 1) exitWith {
		_objects = _posBetween nearEntities [[PLAYER_UNITS,"LandVehicle"],_radius];
		_objects
	};
	[]
};

{
	if ((count (waypoints _unitGroup)) > 9) exitWith {};
	_waypoint = [_unitGroup,getPosATL _x] call A3XAI_addTemporaryWaypoint;
} forEach _searchPoints;

true
