#include "\A3XAI\globaldefines.hpp"

/*
=======================================================================================================================
Script: BIN_taskPatrol.sqf v1.3
Author(s): Binesi
Partly based on original code by BIS

Description:
Creates a continually randomized patrol path which circles and intersects a given position.

Parameter(s):
_this select 0: the group to which to assign the waypoints (Group)
_this select 1: the position on which to base the patrol (Array)
_this select 2: the maximum distance between waypoints (Number)
_this select 3: (optional) debug markers on or off (Number)
_this select 4: (optional) blacklist of areas (Array)

Returns:
Boolean - success flag

Example(s):
null = [group this,(getPos this),250] execVM "BIN_taskPatrol.sqf"
null = [group this,(getPos this),250,1] execVM "BIN_taskPatrol.sqf" // Same with debug markers

-----------------------------------------------------------------------------------------------------------------------
Notes: Wolffy.au
If anyone is interested, I've made some additions to Binesi's BIN_taskPatrol script.
Random initial patrol direction - I noticed every patrol started off in the same direction, so I've randomised it.
Fixed the 2D position / findSafePos errors
Added building positions as possible patrol locations using Random Building Position Script v1.0 by Tophe of Östgöta Ops
Added check that BIS Functions has been initialized

ArmaIIholic 
-- added JTD direction normalization function
-- changed numbers for waypoints to match previous waypoints
-- randomized initial direction - Wolffy.au added only the offset
-- fixed error with building position format
-- randomized initial direction -- Wolffy.au added only the offset which had to be reduced to 180 
           - however this script is making full circle from wherever it starts

Edited version for A3XAI (https://github.com/dayzai/A3XAI)
=======================================================================================================================
*/


_unitGroup = _this select 0;
_pos = _this select 1;
_max_dist = _this select 2;
_unitType = _unitGroup getVariable ["unitType",""];
_allowWater = (_unitType in ["aircustom","air_reinforce"]);
_searchLoot = _unitType in ["static","vehiclecrew","dynamic","random"];
_isVehicle = (_unitType isEqualTo "landcustom");
_combatMode = (combatMode _unitGroup);
_behavior = (behaviour (leader _unitGroup));

if (_max_dist < 75) then {_unitGroup setSpeedMode "LIMITED"};

_randomizeChance = linearConversion [125,350,_max_dist,0.25,0.45,true];
//diag_log format ["DEBUG: PatrolDist %1 has RandomizeChance %2",_max_dist,_randomizeChance];

_wpStatements = call {
	if (_searchLoot && {_max_dist > 100}) exitWith {format ["if !(local this) exitWith {}; if (%1 call A3XAI_chance) then {_nul = [group this] call A3XAI_setRandomWaypoint;} else {_nul = [group this] spawn A3XAI_areaSearching;};",_randomizeChance]};
	if (_unitType isEqualTo "aircustom") exitWith {format ["if !(local this) exitWith {}; if (%1 call A3XAI_chance) then {_nul = [group this] call A3XAI_setRandomWaypoint;} else {_nul = [(assignedVehicle this),(group this)] spawn A3XAI_customHeliDetect;};",_randomizeChance]};
	format ["if !(local this) exitWith {}; if (%1 call A3XAI_chance) then {_nul = [group this] call A3XAI_setRandomWaypoint};",_randomizeChance]
};

_wpTimeouts = if (_max_dist >= 100) then {[0, 3, 5]} else {[3, 6, 9]};

_center_x = (_pos) select 0;
_center_y = (_pos) select 1;
_center_z = (_pos) select 2;
if(isNil "_center_z")then{_center_z = 0;};

_allowInNoAggroArea = ([_pos,NO_AGGRO_RANGE_MAN] call A3XAI_checkInNoAggroArea);
_wp_count = 4 + (floor random 3) + (floor (_max_dist / 100 ));
_angle = (360 / (_wp_count -1));

_newangle = 0;
_wp_array = [];
_slack = _max_dist / 5.5;
_completionRadius = if (_isVehicle) then {(25 + _slack)} else {(10 + _slack)};
if ( _slack < 20 ) then { _slack = 20 };

_angle_offset = random 180;
while {count _wp_array < _wp_count} do {
	private ["_x1","_y1","_wp_pos", "_prepos","_bldgpos","_bldgs","_a","_b"];
	
	_newangle = (count _wp_array * _angle) + _angle_offset;
	
	if ((_newangle > 360) || {_newangle < 0}) then
	{
		_newangle = abs (abs (_newangle) - 360);
	};
			
	if ((random 1) < 0.5) then 
	{
		_newangle = -_newangle;
		
		if ((_newangle > 360) || {_newangle < 0}) then
		 {
			_newangle = abs (abs (_newangle) - 360);
		 };
	};

	_x1 = _center_x - (sin _newangle * _max_dist);
	_y1 = _center_y - (cos _newangle * _max_dist);

	_prepos = [_x1, _y1, _center_z];
	if ( isNil "_center_z" ) then {
		_prepos = [_x1, _y1];
	};

	_wp_pos = [_prepos, 0, _slack, 6, 0, 50 * (pi / 180), 0, [],[_prepos]] call BIS_fnc_findSafePos;
	
	_retry = false;
	if (((surfaceIsWater _wp_pos) && {!_allowWater}) or {([_wp_pos,NO_AGGRO_RANGE_MAN] call A3XAI_checkInNoAggroArea) or {_allowInNoAggroArea}}) then {
		_retry = true;
		_retryCount = 0;
		_retryPos = [];
		_newMaxDist = _max_dist;
		while {_retry && {_retryCount < 2}} do {
			_newMaxDist = _newMaxDist * 0.5;
			_x1 = _center_x - (sin _newangle * _newMaxDist);
			_y1 = _center_y - (cos _newangle * _newMaxDist);

			_prepos = [_x1, _y1, _center_z];
			if ( isNil "_center_z" ) then {
				_prepos = [_x1, _y1];
			};

			_retryPos = [_prepos, 0, _slack, 6, 0, 50 * (pi / 180), 0, [],[_prepos]] call BIS_fnc_findSafePos;
			_retryCount = _retryCount + 1;
			if ((!(surfaceIsWater _wp_pos) or {_allowWater}) && (!([_wp_pos,NO_AGGRO_RANGE_MAN] call A3XAI_checkInNoAggroArea) or {_allowInNoAggroArea})) then {
				_retry = false;
				_wp_pos = _retryPos;
			};
		};
	};

	if !(_retry) then {
		_a = 0 + (_wp_pos select 0);
		_b = 0 + (_wp_pos select 1);
		
		if (_searchLoot) then {
			//////////////////////////////////////////////////////////////////
			// The following code is an extract from Random Building Position Script v1.0 by Tophe of Östgöta Ops
			//////////////////////////////////////////////////////////////////
			_bldgpos = [];
			_bldgs = nearestObjects [[_a,_b,0], ["HouseBase"], 50];
			{
			  private["_i","_y"];
				_i = 0;
				_y = _x buildingPos _i;
				//while {format["%1", _y] != "[0,0,0]"} do {
				while {!(_y isEqualTo [0,0,0]) } do {
					//_bldgpos = _bldgpos + [_y];
					_bldgpos pushBack _y;
					_i = _i + 1;
					_y = _x buildingPos _i;
				};
			} forEach _bldgs;
			
			if(count _bldgpos != 0) then {_wp_pos = _bldgpos call A3XAI_selectRandom;};
		} else {
			if (_isVehicle) then {
				_nearRoads = _wp_pos nearRoads ((_max_dist/2) min 100);
				_roadsCount = count _nearRoads;
				_returnPos = [];
				if (_roadsCount > 0) then {
					_returnPos = getPosATL (_nearRoads select 0);
					if (_roadsCount > 1) then {
						for "_i" from 1 to (_roadsCount -1) do {
							_comparePos = getPosATL (_nearRoads select _i);
							if ((_comparePos distance _wp_pos) < (_returnPos distance _wp_pos)) then {
								_returnPos = _comparePos;
							};
						};
					};
					_wp_pos = _returnPos;
				};
			};
		};
		//_wp_array = _wp_array + [_wp_pos];
		_wp_array pushBack _wp_pos;
	};
	
	uiSleep 0.25;
};

for "_i" from 1 to (_wp_count - 1) do
{
	private ["_wp","_cur_pos"];

	_cur_pos = (_wp_array select _i);
	
	_wp = _unitGroup addWaypoint [_cur_pos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius _completionRadius;
	_wp setWaypointTimeout [_wpTimeouts select 0, _wpTimeouts select 1, _wpTimeouts select 2];
	_wp setWaypointStatements ["true",_wpStatements];
	_wp setWaypointCombatMode _combatMode;
	_wp setWaypointBehaviour _behavior;
	uiSleep 0.25;
};

_endWP = [_pos, 0, 50, 6, 0, 50 * (pi / 180), 0, [],[_pos]] call BIS_fnc_findSafePos;

// End back near start point and then pick a new random point
_wp1 = _unitGroup addWaypoint [_endWP, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointCompletionRadius (_max_dist max 50);
_wp1 setWaypointCombatMode _combatMode;
_wp1 setWaypointBehaviour _behavior;
[_unitGroup,(count waypoints _unitGroup)] setWaypointStatements ["true", "if !(local this) exitWith {}; group this setCurrentWaypoint [(group this), (round (random 2) + 1)];"];

// Cycle in case we reach the end
_wp2 = _unitGroup addWaypoint [_endWP, 0];
_wp2 setWaypointType "CYCLE";
_wp2 setWaypointCompletionRadius (_max_dist max 50);
_wp2 setWaypointCombatMode _combatMode;
_wp2 setWaypointBehaviour _behavior;

for "_i" from ((count (waypoints _unitGroup)) - 1) to 0 step -1 do {
	if ((getWPPos [_unitGroup,_i]) isEqualTo [0,0,0]) then {
		diag_log format ["A3XAI Error: Waypoint %1 is invalid position.",[_unitGroup,_i]];
		deleteWaypoint [_unitGroup,_i];
	};
};

if (A3XAI_enableHC && {_unitType in A3XAI_HCAllowedTypes}) then {_unitGroup setVariable ["HC_Ready",true];};

true
