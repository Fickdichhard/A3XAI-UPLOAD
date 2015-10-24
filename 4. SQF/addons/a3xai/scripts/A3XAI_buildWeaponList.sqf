#include "\A3XAI\globaldefines.hpp"

private ["_startTime", "_checkWeapon", "_magazineTypes", "_cursorAim", "_ammo", "_ammoHit", "_buildWeaponList", "_pistolList", "_rifleList", "_machinegunList", "_sniperList"];

_startTime = diag_tickTime;

if (isNil "A3XAI_dynamicWeaponBlacklist") then {A3XAI_dynamicWeaponBlacklist = [];};

_checkWeapon = 
{
	private ["_magazineTypes","_ammo","_ammoMaxRange","_ammoHit"];
	if ((typeName _this) != "STRING") exitWith {false};
	if (_this in A3XAI_dynamicWeaponBlacklist) exitWith {false};
	_magazineTypes = [configFile >> "CfgWeapons" >> _this,"magazines",[]] call BIS_fnc_returnConfigEntry;
	if (_magazineTypes isEqualTo []) exitWith {false};
	_cursorAim = [configFile >> "CfgWeapons" >> _this,"cursorAim","throw"] call BIS_fnc_returnConfigEntry;
	if (_cursorAim isEqualTo "throw") exitWith {false};
	_ammo = [configFile >> "CfgMagazines" >> (_magazineTypes select 0),"ammo",""] call BIS_fnc_returnConfigEntry;
	if (_ammo isEqualTo "") exitWith {false};
	_ammoHit = [configFile >> "CfgAmmo" >> _ammo,"hit",0] call BIS_fnc_returnConfigEntry;
	if (_ammoHit isEqualTo 0) exitWith {false};
	_weaponPrice = [configFile >> "CfgExileArsenal" >> _this,"price",0] call BIS_fnc_returnConfigEntry;
	if (_weaponPrice > A3XAI_itemPriceLimit) exitWith {if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Item %1 exceeds price limit of %2.",_this,A3XAI_itemPriceLimit];}; false};
	true
};

_buildWeaponList = {
	private ["_items", "_itemClassInfo", "_itemClassBias", "_itemClassType", "_weapon", "_itemClass", "_itemList"];
	_items = [];
	
	{
		if (_x call _checkWeapon) then {
			_items pushBack _x;
		};
	} forEach _this;
	
	_items
};

_pistolList = [missionConfigFile >> "CfgTraderCategories" >> "Pistols","items",[]] call BIS_fnc_returnConfigEntry;
_rifleList = [missionConfigFile >> "CfgTraderCategories" >> "AssaultRifles","items",[]] call BIS_fnc_returnConfigEntry;
_machinegunList = [missionConfigFile >> "CfgTraderCategories" >> "LightMachineGuns","items",[]] call BIS_fnc_returnConfigEntry;
_sniperList = [missionConfigFile >> "CfgTraderCategories" >> "SniperRifles","items",[]] call BIS_fnc_returnConfigEntry;
_submachinegunList = [missionConfigFile >> "CfgTraderCategories" >> "SubMachineGuns","items",[]] call BIS_fnc_returnConfigEntry;
_rifleList append _submachinegunList;

_pistolList = _pistolList call _buildWeaponList;
_rifleList = _rifleList call _buildWeaponList;
_machinegunList = _machinegunList call _buildWeaponList;
_sniperList = _sniperList call _buildWeaponList;

_pistolsLevel0 = [];
_pistolsLevel1 = [];
_pistolsLevel2 = [];
_pistolsLevel3 = [];

_riflesLevel0 = [];
_riflesLevel1 = [];
_riflesLevel2 = [];
_riflesLevel3 = [];

_machinegunsLevel0 = [];
_machinegunsLevel1 = [];
_machinegunsLevel2 = [];
_machinegunsLevel3 = [];

_snipersLevel0 = [];
_snipersLevel1 = [];
_snipersLevel2 = [];
_snipersLevel3 = [];

{
	_itemLevel = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "quality");
	call {
		if (_itemLevel isEqualTo 1) exitWith {
			_pistolsLevel0 pushBack _x;
			_pistolsLevel1 pushBack _x;
		};
		if (_itemLevel isEqualTo 3) exitWith {
			_pistolsLevel2 pushBack _x;
			_pistolsLevel3 pushBack _x;
		};
		
		_pistolsLevel0 pushBack _x;
		_pistolsLevel1 pushBack _x;
		_pistolsLevel2 pushBack _x;
		_pistolsLevel3 pushBack _x;
	};
} forEach _pistolList;

if !(_pistolsLevel0 isEqualTo []) then {A3XAI_pistolList0 = _pistolsLevel0} else {A3XAI_pistolList0 = A3XAI_pistolList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_pistolList0. Classnames from A3XAI_config.sqf used instead.";};
if !(_pistolsLevel1 isEqualTo []) then {A3XAI_pistolList1 = _pistolsLevel1} else {A3XAI_pistolList1 = A3XAI_pistolList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_pistolList1. Classnames from A3XAI_config.sqf used instead.";};
if !(_pistolsLevel2 isEqualTo []) then {A3XAI_pistolList2 = _pistolsLevel2} else {A3XAI_pistolList2 = A3XAI_pistolList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_pistolList2. Classnames from A3XAI_config.sqf used instead.";};
if !(_pistolsLevel3 isEqualTo []) then {A3XAI_pistolList3 = _pistolsLevel3} else {A3XAI_pistolList3 = A3XAI_pistolList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_pistolList3. Classnames from A3XAI_config.sqf used instead.";};
	
{
	_itemLevel = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "quality");
	call {
		if (_itemLevel isEqualTo 1) exitWith {
			_riflesLevel0 pushBack _x;
			_riflesLevel1 pushBack _x;
		};
		if (_itemLevel isEqualTo 3) exitWith {
			_riflesLevel2 pushBack _x;
			_riflesLevel3 pushBack _x;
		};
		
		_riflesLevel0 pushBack _x;
		_riflesLevel1 pushBack _x;
		_riflesLevel2 pushBack _x;
		_riflesLevel3 pushBack _x;
	};
} forEach _rifleList;

if !(_riflesLevel0 isEqualTo []) then {A3XAI_rifleList0 = _riflesLevel0} else {A3XAI_rifleList0 = A3XAI_rifleList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_rifleList0. Classnames from A3XAI_config.sqf used instead.";};
if !(_riflesLevel1 isEqualTo []) then {A3XAI_rifleList1 = _riflesLevel1} else {A3XAI_rifleList1 = A3XAI_rifleList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_rifleList1. Classnames from A3XAI_config.sqf used instead.";};
if !(_riflesLevel2 isEqualTo []) then {A3XAI_rifleList2 = _riflesLevel2} else {A3XAI_rifleList2 = A3XAI_rifleList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_rifleList2. Classnames from A3XAI_config.sqf used instead.";};
if !(_riflesLevel3 isEqualTo []) then {A3XAI_rifleList3 = _riflesLevel3} else {A3XAI_rifleList3 = A3XAI_rifleList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_rifleList3. Classnames from A3XAI_config.sqf used instead.";};

{
	_itemLevel = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "quality");
	call {
		if (_itemLevel isEqualTo 1) exitWith {
			_machinegunsLevel0 pushBack _x;
			_machinegunsLevel1 pushBack _x;
		};
		if (_itemLevel isEqualTo 3) exitWith {
			_machinegunsLevel2 pushBack _x;
			_machinegunsLevel3 pushBack _x;
		};
		
		_machinegunsLevel0 pushBack _x;
		_machinegunsLevel1 pushBack _x;
		_machinegunsLevel2 pushBack _x;
		_machinegunsLevel3 pushBack _x;
	};
} forEach _machinegunList;

if !(_machinegunsLevel0 isEqualTo []) then {A3XAI_machinegunList0 = _machinegunsLevel0} else {A3XAI_machinegunList0 = A3XAI_machinegunList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_machinegunList0. Classnames from A3XAI_config.sqf used instead.";};
if !(_machinegunsLevel1 isEqualTo []) then {A3XAI_machinegunList1 = _machinegunsLevel1} else {A3XAI_machinegunList1 = A3XAI_machinegunList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_machinegunList1. Classnames from A3XAI_config.sqf used instead.";};
if !(_machinegunsLevel2 isEqualTo []) then {A3XAI_machinegunList2 = _machinegunsLevel2} else {A3XAI_machinegunList2 = A3XAI_machinegunList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_machinegunList2. Classnames from A3XAI_config.sqf used instead.";};
if !(_machinegunsLevel3 isEqualTo []) then {A3XAI_machinegunList3 = _machinegunsLevel3} else {A3XAI_machinegunList3 = A3XAI_machinegunList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_machinegunList3. Classnames from A3XAI_config.sqf used instead.";};

{
	_itemLevel = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "quality");
	call {
		if (_itemLevel isEqualTo 1) exitWith {
			_snipersLevel0 pushBack _x;
			_snipersLevel1 pushBack _x;
		};
		if (_itemLevel isEqualTo 3) exitWith {
			_snipersLevel2 pushBack _x;
			_snipersLevel3 pushBack _x;
		};
		
		_snipersLevel0 pushBack _x;
		_snipersLevel1 pushBack _x;
		_snipersLevel2 pushBack _x;
		_snipersLevel3 pushBack _x;
	};
} forEach _sniperList;

if !(_snipersLevel0 isEqualTo []) then {A3XAI_sniperList0 = _snipersLevel0} else {A3XAI_sniperList0 = A3XAI_sniperList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_sniperList0. Classnames from A3XAI_config.sqf used instead.";};
if !(_snipersLevel1 isEqualTo []) then {A3XAI_sniperList1 = _snipersLevel1} else {A3XAI_sniperList1 = A3XAI_sniperList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_sniperList1. Classnames from A3XAI_config.sqf used instead.";};
if !(_snipersLevel2 isEqualTo []) then {A3XAI_sniperList2 = _snipersLevel2} else {A3XAI_sniperList2 = A3XAI_sniperList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_sniperList2. Classnames from A3XAI_config.sqf used instead.";};
if !(_snipersLevel3 isEqualTo []) then {A3XAI_sniperList3 = _snipersLevel3} else {A3XAI_sniperList3 = A3XAI_sniperList; diag_log "A3XAI Error: Could not dynamically generate A3XAI_sniperList3. Classnames from A3XAI_config.sqf used instead.";};

if (A3XAI_debugLevel > 0) then {
	if (A3XAI_debugLevel > 1) then {
		//Display finished weapon arrays
		if (!isNil "A3XAI_pistolList0") then {diag_log format ["Contents of A3XAI_pistolList0: %1",A3XAI_pistolList0];};
		if (!isNil "A3XAI_rifleList0") then {diag_log format ["Contents of A3XAI_rifleList0: %1",A3XAI_rifleList0];};
		if (!isNil "A3XAI_machinegunList0") then {diag_log format ["Contents of A3XAI_machinegunList0: %1",A3XAI_machinegunList0];};
		if (!isNil "A3XAI_sniperList0") then {diag_log format ["Contents of A3XAI_sniperList0: %1",A3XAI_sniperList0];};
		
		if (!isNil "A3XAI_pistolList1") then {diag_log format ["Contents of A3XAI_pistolList1: %1",A3XAI_pistolList1];};
		if (!isNil "A3XAI_rifleList1") then {diag_log format ["Contents of A3XAI_rifleList1: %1",A3XAI_rifleList1];};
		if (!isNil "A3XAI_machinegunList1") then {diag_log format ["Contents of A3XAI_machinegunList1: %1",A3XAI_machinegunList1];};
		if (!isNil "A3XAI_sniperList1") then {diag_log format ["Contents of A3XAI_sniperList1: %1",A3XAI_sniperList1];};
		
		if (!isNil "A3XAI_pistolList2") then {diag_log format ["Contents of A3XAI_pistolList2: %1",A3XAI_pistolList2];};
		if (!isNil "A3XAI_rifleList2") then {diag_log format ["Contents of A3XAI_rifleList2: %1",A3XAI_rifleList2];};
		if (!isNil "A3XAI_machinegunList2") then {diag_log format ["Contents of A3XAI_machinegunList2: %1",A3XAI_machinegunList2];};
		if (!isNil "A3XAI_sniperList2") then {diag_log format ["Contents of A3XAI_sniperList2: %1",A3XAI_sniperList2];};
		
		if (!isNil "A3XAI_pistolList3") then {diag_log format ["Contents of A3XAI_pistolList3: %1",A3XAI_pistolList3];};
		if (!isNil "A3XAI_rifleList3") then {diag_log format ["Contents of A3XAI_rifleList3: %1",A3XAI_rifleList3];};
		if (!isNil "A3XAI_machinegunList3") then {diag_log format ["Contents of A3XAI_machinegunList3: %1",A3XAI_machinegunList3];};
		if (!isNil "A3XAI_sniperList3") then {diag_log format ["Contents of A3XAI_sniperList3: %1",A3XAI_sniperList3];};
	};
	diag_log format ["A3XAI Debug: Weapon classname tables created in %1 seconds.",(diag_tickTime - _startTime)];
};

//Clean up global vars
A3XAI_dynamicWeaponBlacklist = nil;

