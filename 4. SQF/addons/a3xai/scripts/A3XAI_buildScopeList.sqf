#include "\A3XAI\globaldefines.hpp"

private ["_startTime", "_scopeList", "_items", "_itemClassInfo", "_itemClassBias", "_itemClassType", "_itemList", "_itemInfo", "_itemBias", "_itemType", "_item","_itemClass"];

_startTime = diag_tickTime;

_items = [missionConfigFile >> "CfgTraderCategories" >> "OpticAttachments","items",[]] call BIS_fnc_returnConfigEntry;

if !(A3XAI_dynamicOpticsBlacklist isEqualTo []) then {
	_items = _items - A3XAI_dynamicOpticsBlacklist;
};

{
	_itemPrice = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "price");
	if (_itemPrice > A3XAI_itemPriceLimit) then {
		_items deleteAt _forEachIndex;
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Item %1 exceeds price limit of %2.",_x,A3XAI_itemPriceLimit];};
	};
} forEach _items;

if !(_items isEqualTo []) then {
	A3XAI_weaponOpticsList = _items;
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Generated %1 weapon optics classnames in %2 seconds.",(count _items),diag_tickTime - _startTime];
		if (A3XAI_debugLevel > 1) then {
			diag_log format ["A3XAI Debug: Contents of A3XAI_weaponOpticsList: %1",A3XAI_weaponOpticsList];
		};
	};
} else {
	diag_log "A3XAI Error: Could not dynamically generate weapon optics classname list. Classnames from A3XAI_config.sqf used instead.";
};

//Cleanup global vars
A3XAI_dynamicOpticsBlacklist = nil;
