#include "\A3XAI\globaldefines.hpp"

private ["_startTime", "_items", "_backpacksLevel0", "_backpacksLevel1", "_backpacksLevel2", "_backpacksLevel3", "_itemLevel"];

_startTime = diag_tickTime;

_items = [missionConfigFile >> "CfgTraderCategories" >> "Backpacks","items",[]] call BIS_fnc_returnConfigEntry;

if !(A3XAI_dynamicBackpackBlacklist isEqualTo []) then {
	_items = _items - A3XAI_dynamicBackpackBlacklist;
};

_backpacksLevel0 = [];
_backpacksLevel1 = [];
_backpacksLevel2 = [];
_backpacksLevel3 = [];

if !(_items isEqualTo []) then {
	{
		_itemPrice = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "price");
		if (_itemPrice < A3XAI_itemPriceLimit) then {
			_itemLevel = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "quality");
			call {
				if (_itemLevel isEqualTo 1) exitWith {
					_backpacksLevel0 pushBack _x;
					_backpacksLevel1 pushBack _x;
				};
				if (_itemLevel isEqualTo 2) exitWith {
					_backpacksLevel1 pushBack _x;
					_backpacksLevel2 pushBack _x;
				};
				if (_itemLevel isEqualTo 3) exitWith {
					_backpacksLevel2 pushBack _x;
					_backpacksLevel3 pushBack _x;
				};
				
				_backpacksLevel0 pushBack _x;
				_backpacksLevel1 pushBack _x;
				_backpacksLevel2 pushBack _x;
				_backpacksLevel3 pushBack _x;
			};
		} else {
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Item %1 exceeds price limit of %2.",_x,A3XAI_itemPriceLimit];};
		};
	} forEach _items;
	
	if !(_backpacksLevel0 isEqualTo []) then {A3XAI_backpackTypes0 = _backpacksLevel0} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_backpackTypes0. Classnames from A3XAI_config.sqf used instead.";};
	if !(_backpacksLevel1 isEqualTo []) then {A3XAI_backpackTypes1 = _backpacksLevel1} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_backpackTypes1. Classnames from A3XAI_config.sqf used instead.";};
	if !(_backpacksLevel2 isEqualTo []) then {A3XAI_backpackTypes2 = _backpacksLevel2} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_backpackTypes2. Classnames from A3XAI_config.sqf used instead.";};
	if !(_backpacksLevel3 isEqualTo []) then {A3XAI_backpackTypes3 = _backpacksLevel3} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_backpackTypes3. Classnames from A3XAI_config.sqf used instead.";};
	
	if (A3XAI_debugLevel > 0) then {
		diag_log format ["A3XAI Debug: Generated %1 backpack classnames in %2 seconds.",(count _items),diag_tickTime - _startTime];
		if (A3XAI_debugLevel > 1) then {
			diag_log format ["A3XAI Debug: Contents of A3XAI_backpackTypes0: %1",A3XAI_backpackTypes0];
			diag_log format ["A3XAI Debug: Contents of A3XAI_backpackTypes1: %1",A3XAI_backpackTypes1];
			diag_log format ["A3XAI Debug: Contents of A3XAI_backpackTypes2: %1",A3XAI_backpackTypes2];
			diag_log format ["A3XAI Debug: Contents of A3XAI_backpackTypes3: %1",A3XAI_backpackTypes3];
		};
	};
} else {
	diag_log "A3XAI Error: Could not dynamically generate backpack classname list. Classnames from A3XAI_config.sqf used instead.";
};

//Cleanup global vars
A3XAI_dynamicBackpackBlacklist = nil;
A3XAI_dynamicBackpackLevels = nil;
