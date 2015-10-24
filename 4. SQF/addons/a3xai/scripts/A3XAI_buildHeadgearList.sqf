#include "\A3XAI\globaldefines.hpp"

private ["_startTime", "_items", "_headgearsLevel0", "_headgearsLevel1", "_headgearsLevel2", "_headgearsLevel3", "_itemLevel"];

_startTime = diag_tickTime;

_items = [missionConfigFile >> "CfgTraderCategories" >> "Headgear","items",[]] call BIS_fnc_returnConfigEntry;

if !(A3XAI_dynamicHeadgearBlacklist isEqualTo []) then {
	_items = _items - A3XAI_dynamicHeadgearBlacklist;
};

_headgearsLevel0 = [];
_headgearsLevel1 = [];
_headgearsLevel2 = [];
_headgearsLevel3 = [];

if !(_items isEqualTo []) then {
	{
		_itemPrice = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "price");
		if (_itemPrice < A3XAI_itemPriceLimit) then {
			_itemLevel = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "quality");
			call {
				if (_itemLevel isEqualTo 1) exitWith {
					_headgearsLevel0 pushBack _x;
					_headgearsLevel1 pushBack _x;
				};
				if (_itemLevel isEqualTo 2) exitWith {
					_headgearsLevel1 pushBack _x;
					_headgearsLevel2 pushBack _x;
				};
				if (_itemLevel isEqualTo 3) exitWith {
					_headgearsLevel2 pushBack _x;
					_headgearsLevel3 pushBack _x;
				};
				
				_headgearsLevel0 pushBack _x;
				_headgearsLevel1 pushBack _x;
				_headgearsLevel2 pushBack _x;
				_headgearsLevel3 pushBack _x;
			};
		} else {
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Item %1 exceeds price limit of %2.",_x,A3XAI_itemPriceLimit];};
		};
		
	} forEach _items;
	
	if !(_headgearsLevel0 isEqualTo []) then {A3XAI_headgearTypes0 = _headgearsLevel0} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_headgearTypes0. Classnames from A3XAI_config.sqf used instead.";};
	if !(_headgearsLevel1 isEqualTo []) then {A3XAI_headgearTypes1 = _headgearsLevel1} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_headgearTypes1. Classnames from A3XAI_config.sqf used instead.";};
	if !(_headgearsLevel2 isEqualTo []) then {A3XAI_headgearTypes2 = _headgearsLevel2} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_headgearTypes2. Classnames from A3XAI_config.sqf used instead.";};
	if !(_headgearsLevel3 isEqualTo []) then {A3XAI_headgearTypes3 = _headgearsLevel3} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_headgearTypes3. Classnames from A3XAI_config.sqf used instead.";};
	
	if (A3XAI_debugLevel > 0) then {
		diag_log format ["A3XAI Debug: Generated %1 headgear classnames in %2 seconds.",(count _items),diag_tickTime - _startTime];
		if (A3XAI_debugLevel > 1) then {
			diag_log format ["A3XAI Debug: Contents of A3XAI_headgearTypes0: %1",A3XAI_headgearTypes0];
			diag_log format ["A3XAI Debug: Contents of A3XAI_headgearTypes1: %1",A3XAI_headgearTypes1];
			diag_log format ["A3XAI Debug: Contents of A3XAI_headgearTypes2: %1",A3XAI_headgearTypes2];
			diag_log format ["A3XAI Debug: Contents of A3XAI_headgearTypes3: %1",A3XAI_headgearTypes3];
		};
	};
} else {
	diag_log "A3XAI Error: Could not dynamically generate headgear classname list. Classnames from A3XAI_config.sqf used instead.";
};

//Cleanup global vars
A3XAI_dynamicHeadgearBlacklist = nil;
A3XAI_dynamicHeadgearLevels = nil;
