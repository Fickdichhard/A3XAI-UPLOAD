#include "\A3XAI\globaldefines.hpp"

private ["_startTime", "_items", "_vestsLevel0", "_vestsLevel1", "_vestsLevel2", "_vestsLevel3", "_itemLevel"];

_startTime = diag_tickTime;

_items = [missionConfigFile >> "CfgTraderCategories" >> "Vests","items",[]] call BIS_fnc_returnConfigEntry;

if !(A3XAI_dynamicVestBlacklist isEqualTo []) then {
	_items = _items - A3XAI_dynamicVestBlacklist;
};

_vestsLevel0 = [];
_vestsLevel1 = [];
_vestsLevel2 = [];
_vestsLevel3 = [];

if !(_items isEqualTo []) then {
	{
		_itemPrice = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "price");
		if (_itemPrice < A3XAI_itemPriceLimit) then {
			_itemLevel = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "quality");
			call {
				if (_itemLevel isEqualTo 1) exitWith {
					_vestsLevel0 pushBack _x;
					_vestsLevel1 pushBack _x;
				};
				if (_itemLevel isEqualTo 2) exitWith {
					_vestsLevel1 pushBack _x;
					_vestsLevel2 pushBack _x;
				};
				if (_itemLevel isEqualTo 3) exitWith {
					_vestsLevel2 pushBack _x;
					_vestsLevel3 pushBack _x;
				};
				
				_vestsLevel0 pushBack _x;
				_vestsLevel1 pushBack _x;
				_vestsLevel2 pushBack _x;
				_vestsLevel3 pushBack _x;
			};
		} else {
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Item %1 exceeds price limit of %2.",_x,A3XAI_itemPriceLimit];};
		};
	} forEach _items;
	
	if !(_vestsLevel0 isEqualTo []) then {A3XAI_vestTypes0 = _vestsLevel0} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_vestTypes0. Classnames from A3XAI_config.sqf used instead.";};
	if !(_vestsLevel1 isEqualTo []) then {A3XAI_vestTypes1 = _vestsLevel1} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_vestTypes1. Classnames from A3XAI_config.sqf used instead.";};
	if !(_vestsLevel2 isEqualTo []) then {A3XAI_vestTypes2 = _vestsLevel2} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_vestTypes2. Classnames from A3XAI_config.sqf used instead.";};
	if !(_vestsLevel3 isEqualTo []) then {A3XAI_vestTypes3 = _vestsLevel3} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_vestTypes3. Classnames from A3XAI_config.sqf used instead.";};
	
	if (A3XAI_debugLevel > 0) then {
		diag_log format ["A3XAI Debug: Generated %1 vest classnames in %2 seconds.",(count _items),diag_tickTime - _startTime];
		if (A3XAI_debugLevel > 1) then {
			diag_log format ["A3XAI Debug: Contents of A3XAI_vestTypes0: %1",A3XAI_vestTypes0];
			diag_log format ["A3XAI Debug: Contents of A3XAI_vestTypes1: %1",A3XAI_vestTypes1];
			diag_log format ["A3XAI Debug: Contents of A3XAI_vestTypes2: %1",A3XAI_vestTypes2];
			diag_log format ["A3XAI Debug: Contents of A3XAI_vestTypes3: %1",A3XAI_vestTypes3];
		};
	};
} else {
	diag_log "A3XAI Error: Could not dynamically generate vest classname list. Classnames from A3XAI_config.sqf used instead.";
};

//Cleanup global vars
A3XAI_dynamicVestBlacklist = nil;
