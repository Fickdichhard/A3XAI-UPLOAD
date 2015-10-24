#include "\A3XAI\globaldefines.hpp"

private ["_cfgWorldName","_startTime","_allPlaces","_allLocations","_traderCityPositions","_traderCityMarkers"];

_startTime = diag_tickTime;
_allPlaces = [];
_allLocations = [];
_cfgWorldName = configFile >> "CfgWorlds" >> worldName >> "Names";

for "_i" from 0 to ((count _cfgWorldName) -1) do {
	_allPlaces set [(count _allPlaces),configName (_cfgWorldName select _i)];
	//diag_log format ["DEBUG :: Added location %1 to allPlaces array.",configName (_cfgWorldName select _i)];
};

//Add user-specified blacklist areas
{
	A3XAI_waypointBlacklistAir set [_forEachIndex,(toLower _x)]; //Ensure case-insensitivity
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Created AI vehicle waypoint blacklist at %1.",_x];};
	if ((_forEachIndex % 3) isEqualTo 0) then {uiSleep 0.05};
} forEach A3XAI_waypointBlacklistAir;

{
	A3XAI_waypointBlacklistLand set [_forEachIndex,(toLower _x)]; //Ensure case-insensitivity
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Created AI vehicle waypoint blacklist at %1.",_x];};
	if ((_forEachIndex % 3) isEqualTo 0) then {uiSleep 0.05};
} forEach A3XAI_waypointBlacklistLand;

//Set up trader city blacklist areas
_traderCityPositions = [];
call {
	{
		if ((triggerStatements _x) isEqualTo ["(vehicle player) in thisList","call ExileClient_object_player_event_onEnterSafezone","call ExileClient_object_player_event_onLeaveSafezone"]) then {
			_traderCityPositions pushBack (getPosATL _x);
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Found trader safezone at %1",getPosATL _x];};
		};
	} forEach (allMissionObjects "EmptyDetector");
	
	if !(_traderCityPositions isEqualTo []) exitWith {};
	
	{
		if ((markerType _x) isEqualTo "ExileTraderZone") then {
			_traderCityPositions pushBack (getMarkerPos _x);
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Found trader marker %1",_x];};
		};
	} forEach allMapMarkers;

	if !(_traderCityPositions isEqualTo []) exitWith {};
	
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Could not automatically detect any trader locations. Reading trader locations from A3XAI_traderAreaLocations."];};
	{
		call {
			if ((typeName _x) != "ARRAY") exitWith {diag_log "A3XAI Error: Non-array value found in A3XAI_traderAreaLocations";};
			if ((count _x) < 2) exitWith {diag_log "A3XAI Error: Array value with fewer than 2 elements found in A3XAI_traderAreaLocations";};
			_traderCityPositions pushBack _x;
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Found trader location at %1",_x];};
		};
	} forEach A3XAI_traderAreaLocations;
	
	if (_traderCityPositions isEqualTo []) then {
		diag_log "A3XAI Warning: Could not automatically detect trader safezones and no manually defined positions found in A3XAI_traderAreaLocations.";
	};
};

{
	_location = [_x,NO_AGGRO_AREA_SIZE] call A3XAI_createNoAggroArea;
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Created %1m radius no-aggro area at trader city position %2.",NO_AGGRO_AREA_SIZE,_x];};
	_location = [_x,BLACKLIST_AREA_SIZE] call A3XAI_createBlackListArea;
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Created %1m radius blacklist area at trader city position %2.",BLACKLIST_AREA_SIZE,_x];};
} forEach _traderCityPositions;

{
	_placeType = toLower (getText (_cfgWorldName >> _x >> "type"));
	if (_placeType in ["namecitycapital","namecity","namevillage","namelocal"]) then {
		_placeName = getText (_cfgWorldName >> _x >> "name");
		_placePos = getArray (_cfgWorldName >> _x >> "position");
		_isAllowedPos = (({(_placePos distance2D _x) < NO_AGGRO_AREA_SIZE} count _traderCityPositions) isEqualTo 0);
		if (_isAllowedPos) then {
			A3XAI_locations pushBack [_placeName,_placePos,_placeType];
			if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Added location %1 (type: %2, pos: %3) to location list.",_placeName,_placeType,_placePos];};
			if !(_placeName in A3XAI_waypointBlacklistAir) then {A3XAI_locationsAir pushBack [_placeName,_placePos,_placeType];};
			if !((_placeName in A3XAI_waypointBlacklistLand) && {!(surfaceIsWater _placePos)}) then {A3XAI_locationsLand pushBack [_placeName,_placePos,_placeType];};
		} else {
			if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: %1 not in allowed position. Blacklist (Air): %2, Blacklist (Land): %3. Trader: %4.",_placeName,!((toLower _placeName) in A3XAI_waypointBlacklistAir),!((toLower _placeName) in A3XAI_waypointBlacklistLand),(({(_placePos distance2D _x) < NO_AGGRO_AREA_SIZE} count _traderCityPositions) isEqualTo 0)];};
		};
		_allLocations pushBack [_placeName,_placePos,_placeType];
	};
	if ((_forEachIndex % 10) isEqualTo 0) then {uiSleep 0.05};
} forEach _allPlaces;

//Auto-adjust random spawn limit
if (isDedicated && {A3XAI_maxRandomSpawns isEqualTo -1}) then {
	A3XAI_maxRandomSpawns = ((round (0.10 * (count _allLocations)) min 15) max 5);
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Adjusted random spawn limit to %1",A3XAI_maxRandomSpawns];};
};

if (A3XAI_locations isEqualTo []) then {
	A3XAI_locations = +_allLocations;
	if (A3XAI_debugLevel > 1) then {diag_log "A3XAI Debug: A3XAI_locations is empty, using _allLocations array instead.";};
};

if (A3XAI_locationsAir isEqualTo []) then {
	A3XAI_locationsAir = +_allLocations;
	if (A3XAI_debugLevel > 1) then {diag_log "A3XAI Debug: A3XAI_locationsAir is empty, using _allLocations array instead.";};
};

if (A3XAI_locationsLand isEqualTo []) then {
	A3XAI_locationsLand = +_allLocations;
	if (A3XAI_debugLevel > 1) then {diag_log "A3XAI Debug: A3XAI_locationsLand is empty, using _allLocations array instead.";};
};

A3XAI_locations_ready = true;

//Cleanup global vars
A3XAI_waypointBlacklistAir = nil;
A3XAI_waypointBlacklistLand = nil;

if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Location configuration completed with %1 locations found in %2 seconds.",(count A3XAI_locations),(diag_tickTime - _startTime)]};
