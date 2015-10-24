#include "\A3XAI\globaldefines.hpp"

private ["_startTime", "_items", "_uniformsLevel0", "_uniformsLevel1", "_uniformsLevel2", "_uniformsLevel3", "_itemLevel"];

_startTime = diag_tickTime;

_items = [missionConfigFile >> "CfgTraderCategories" >> "Uniforms","items",[]] call BIS_fnc_returnConfigEntry;

if !(A3XAI_dynamicUniformBlacklist isEqualTo []) then {
	_items = _items - A3XAI_dynamicUniformBlacklist;
};

_uniformsLevel0 = [];
_uniformsLevel1 = [];
_uniformsLevel2 = [];
_uniformsLevel3 = [];

if !(_items isEqualTo []) then {
	{
		_itemPrice = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "price");
		if (_itemPrice < A3XAI_itemPriceLimit) then {
			_itemLevel = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "quality");
			call {
				if (_itemLevel isEqualTo 1) exitWith {
					_uniformsLevel0 pushBack _x;
					_uniformsLevel1 pushBack _x;
				};
				if (_itemLevel isEqualTo 2) exitWith {
					_uniformsLevel1 pushBack _x;
					_uniformsLevel2 pushBack _x;
				};
				if (_itemLevel isEqualTo 3) exitWith {
					_uniformsLevel2 pushBack _x;
					_uniformsLevel3 pushBack _x;
				};
				
				_uniformsLevel0 pushBack _x;
				_uniformsLevel1 pushBack _x;
				_uniformsLevel2 pushBack _x;
				_uniformsLevel3 pushBack _x;
			};
		} else {
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Item %1 exceeds price limit of %2.",_x,A3XAI_itemPriceLimit];};
		};
	} forEach _items;
	
	if !(_uniformsLevel0 isEqualTo []) then {A3XAI_uniformTypes0 = _uniformsLevel0} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_uniformTypes0. Classnames from A3XAI_config.sqf used instead.";};
	if !(_uniformsLevel1 isEqualTo []) then {A3XAI_uniformTypes1 = _uniformsLevel1} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_uniformTypes1. Classnames from A3XAI_config.sqf used instead.";};
	if !(_uniformsLevel2 isEqualTo []) then {A3XAI_uniformTypes2 = _uniformsLevel2} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_uniformTypes2. Classnames from A3XAI_config.sqf used instead.";};
	if !(_uniformsLevel3 isEqualTo []) then {A3XAI_uniformTypes3 = _uniformsLevel3} else {diag_log "A3XAI Error: Could not dynamically generate A3XAI_uniformTypes3. Classnames from A3XAI_config.sqf used instead.";};
	
	if (A3XAI_debugLevel > 0) then {
		diag_log format ["A3XAI Debug: Generated %1 uniform classnames in %2 seconds.",(count _items),diag_tickTime - _startTime];
		if (A3XAI_debugLevel > 1) then {
			diag_log format ["A3XAI Debug: Contents of A3XAI_uniformTypes0: %1",A3XAI_uniformTypes0];
			diag_log format ["A3XAI Debug: Contents of A3XAI_uniformTypes1: %1",A3XAI_uniformTypes1];
			diag_log format ["A3XAI Debug: Contents of A3XAI_uniformTypes2: %1",A3XAI_uniformTypes2];
			diag_log format ["A3XAI Debug: Contents of A3XAI_uniformTypes3: %1",A3XAI_uniformTypes3];
		};
	};
} else {
	diag_log "A3XAI Error: Could not dynamically generate uniform classname list. Classnames from A3XAI_config.sqf used instead.";
};

//Cleanup global vars
A3XAI_dynamicUniformBlacklist = nil;
A3XAI_dynamicUniformLevels = nil;
