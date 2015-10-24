#include "\A3XAI\globaldefines.hpp"

private ["_startTime", "_lootListLarge1", "_lootListLarge2", "_lootListLarge", "_items", "_itemClassInfo", "_itemClassBias", "_itemClassType", "_item", "_itemSubClass", "_itemList", "_itemInfo", "_itemBias", "_itemType"];

_startTime = diag_tickTime;

_loot0 = [missionConfigFile >> "CfgTraderCategories" >> "Hardware","items",[]] call BIS_fnc_returnConfigEntry;
_loot1 = [missionConfigFile >> "CfgTraderCategories" >> "Flares","items",[]] call BIS_fnc_returnConfigEntry;
_loot2 = [missionConfigFile >> "CfgTraderCategories" >> "Smokes","items",[]] call BIS_fnc_returnConfigEntry;

_items = [];

{
	_items append _x;
} forEach [_loot0,_loot1,_loot2];

if !(A3XAI_dynamicLootBlacklist isEqualTo []) then {
	_items = _items - A3XAI_dynamicLootBlacklist;
};

{
	_itemPrice = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "price");
	if (_itemPrice > A3XAI_itemPriceLimit) then {
		_items deleteAt _forEachIndex;
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Item %1 exceeds price limit of %2.",_x,A3XAI_itemPriceLimit];};
	};
} forEach _items;

if !(_items isEqualTo []) then {
	A3XAI_MiscLoot = _items;
	if (A3XAI_debugLevel > 0) then {
		diag_log format ["A3XAI Debug: Generated %1 generic loot classnames in %2 seconds.",(count _items),diag_tickTime - _startTime];
		if (A3XAI_debugLevel > 1) then {
			diag_log format ["A3XAI Debug: Contents of A3XAI_MiscLoot: %1",A3XAI_MiscLoot];
		};
	};
} else {
	diag_log "A3XAI Error: Could not dynamically generate loot classname list. Classnames from A3XAI_config.sqf used instead.";
};

//Cleanup global vars
A3XAI_dynamicLootBlacklist = nil;
