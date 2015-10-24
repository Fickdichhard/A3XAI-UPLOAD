#include "\A3XAI\globaldefines.hpp"

/*
	A3XAI Startup
	
	Description: Handles post-initialization tasks

*/

if (A3XAI_debugLevel > 0) then {diag_log "A3XAI Debug: A3XAI Startup is running required script files..."};

call compile preprocessFileLineNumbers format ["%1\init\variables.sqf",A3XAI_directory];
call compile preprocessFileLineNumbers format ["%1\init\variables_precalculated.sqf",A3XAI_directory];

if (A3XAI_enableHC) then {
	[] call compile preprocessFileLineNumbers format ["%1\init\A3XAI_ServerHC_functions.sqf",A3XAI_directory];
	[] call compile preprocessFileLineNumbers format ["%1\init\A3XAI_ServerHC_PVEH.sqf",A3XAI_directory];
	diag_log "[A3XAI] A3XAI is now listening for headless client connection.";
};

//Create default trigger object if AI is spawned without trigger object specified (ie: for custom vehicle AI groups)
_nul = [] spawn {
	A3XAI_defaultTrigger = createTrigger [TRIGGER_OBJECT,[configFile >> "CfgWorlds" >> worldName,"centerPosition",[0,0,0]] call BIS_fnc_returnConfigEntry,false];
	A3XAI_defaultTrigger enableSimulation false;
	A3XAI_defaultTrigger setVariable ["isCleaning",true];
	A3XAI_defaultTrigger setVariable ["patrolDist",100];
	A3XAI_defaultTrigger setVariable ["unitLevel",1];
	A3XAI_defaultTrigger setVariable ["unitLevelEffective",1];
	A3XAI_defaultTrigger setVariable ["locationArray",[]];
	A3XAI_defaultTrigger setVariable ["maxUnits",[0,0]];
	A3XAI_defaultTrigger setVariable ["GroupSize",0];
	A3XAI_defaultTrigger setVariable ["initialized",true];
	A3XAI_defaultTrigger setVariable ["spawnChance",0];
	A3XAI_defaultTrigger setVariable ["spawnType",""];
	A3XAI_defaultTrigger setTriggerText "Default Trigger Object";
	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Default trigger check result: %1",[!(isNull A3XAI_defaultTrigger),(typeOf A3XAI_defaultTrigger),(getPosASL A3XAI_defaultTrigger)]]};
};

[
	//Input variable - Gradechances array, Output variable - Gradeindices array
	["A3XAI_levelChancesAir","A3XAI_levelIndicesAir"],
	["A3XAI_levelChancesLand","A3XAI_levelIndicesLand"],
	["A3XAI_levelChancesUAV","A3XAI_levelIndicesUAV"],
	["A3XAI_levelChancesUGV","A3XAI_levelIndicesUGV"],
	["A3XAI_useWeaponChance0","A3XAI_weaponTypeIndices0"],
	["A3XAI_useWeaponChance1","A3XAI_weaponTypeIndices1"],
	["A3XAI_useWeaponChance2","A3XAI_weaponTypeIndices2"],
	["A3XAI_useWeaponChance3","A3XAI_weaponTypeIndices3"]
] call compile preprocessFileLineNumbers format ["%1\scripts\buildWeightedTables.sqf",A3XAI_directory];

if (A3XAI_verifyClassnames) then {
	A3XAI_tableChecklist = ["A3XAI_pistolList0","A3XAI_rifleList0","A3XAI_machinegunList0","A3XAI_sniperList0","A3XAI_pistolList1","A3XAI_rifleList1","A3XAI_machinegunList1","A3XAI_sniperList1",
	"A3XAI_pistolList2","A3XAI_rifleList2","A3XAI_machinegunList2","A3XAI_sniperList2","A3XAI_headgearTypes0","A3XAI_headgearTypes1","A3XAI_headgearTypes2","A3XAI_headgearTypes3",
	"A3XAI_pistolList3","A3XAI_rifleList3","A3XAI_machinegunList3","A3XAI_sniperList3","A3XAI_backpackTypes0","A3XAI_backpackTypes1","A3XAI_backpackTypes2","A3XAI_backpackTypes3",
	"A3XAI_pistolList","A3XAI_rifleList","A3XAI_machinegunList","A3XAI_sniperList","A3XAI_foodLoot","A3XAI_MiscLoot1","A3XAI_MiscLoot2","A3XAI_airReinforcementVehicles","A3XAI_uniformTypes0",
	"A3XAI_uniformTypes1","A3XAI_uniformTypes2","A3XAI_uniformTypes3","A3XAI_launcherTypes",
	"A3XAI_vestTypes0","A3XAI_vestTypes1","A3XAI_vestTypes2","A3XAI_vestTypes3"];
};


if (A3XAI_generateDynamicUniforms) then {
	_skinlist = [] execVM format ['%1\scripts\A3XAI_buildUniformList.sqf',A3XAI_directory];
	waitUntil {uiSleep 0.05; scriptDone _skinlist};
};

//Build weapon classname tables
if (A3XAI_generateDynamicWeapons) then {
	_weaponlist = [] execVM format ['%1\scripts\A3XAI_buildWeaponList.sqf',A3XAI_directory];
	waitUntil {uiSleep 0.05; scriptDone _weaponlist};
};

//Build backpack classname tables
if (A3XAI_generateDynamicBackpacks) then {
	_backpacklist = [] execVM format ['%1\scripts\A3XAI_buildBackpackList.sqf',A3XAI_directory];
	waitUntil {uiSleep 0.05; scriptDone _backpacklist};
};

//Build vest classname tables
if (A3XAI_generateDynamicVests) then {
	_vestlist = [] execVM format ['%1\scripts\A3XAI_buildVestList.sqf',A3XAI_directory];
	waitUntil {uiSleep 0.05; scriptDone _vestlist};
};

//Build headgear classname tables
if (A3XAI_generateDynamicHeadgear) then {
	_headgearlist = [] execVM format ['%1\scripts\A3XAI_buildHeadgearList.sqf',A3XAI_directory];
	waitUntil {uiSleep 0.05; scriptDone _headgearlist};
};

//Build food classname tables (1)
if (A3XAI_generateDynamicFood) then {
	_foodlist = [] execVM format ['%1\scripts\A3XAI_buildFoodList.sqf',A3XAI_directory];
	waitUntil {uiSleep 0.05; scriptDone _foodlist};
};

//Build generic loot classname tables (1)
if (A3XAI_generateDynamicLoot) then {
	_lootlist = [] execVM format ['%1\scripts\A3XAI_buildLootList.sqf',A3XAI_directory];
	waitUntil {uiSleep 0.05; scriptDone _lootlist};
};

if (A3XAI_generateDynamicOptics) then {
	_weaponScopes = [] execVM format ['%1\scripts\A3XAI_buildScopeList.sqf',A3XAI_directory];
	waitUntil {uiSleep 0.05; scriptDone _weaponScopes};
};

//Check classname tables if enabled
if (A3XAI_verifyClassnames) then {
	_verifyClassnames = [] execVM format ["%1\scripts\verifyClassnames.sqf",A3XAI_directory];
	waitUntil {uiSleep 0.05; scriptDone _verifyClassnames};
};

if (A3XAI_enableHC && {A3XAI_waitForHC}) then {
	diag_log "[A3XAI] Waiting for headless client to connect. A3XAI post-initialization process paused.";
	waitUntil {uiSleep 5; A3XAI_HCIsConnected};
	diag_log format ["[A3XAI] Headless client connected with owner ID %1. A3XAI post-initialization process continuing.",A3XAI_HCObjectOwnerID];
};

A3XAI_classnamesVerified = true;

//Build map location list.
_setupLocations = [] execVM format ['%1\scripts\setup_locations.sqf',A3XAI_directory];

//Set up auto-generated static spawns
if (A3XAI_enableStaticSpawns) then {
	_staticSpawns = [] execVM format ["%1\scripts\generateStaticSpawns.sqf",A3XAI_directory];
};

//Start dynamic spawn manager
if !(A3XAI_maxDynamicSpawns isEqualTo 0) then {
	_dynManagerV2 = [] execVM format ['%1\scripts\dynamicSpawn_manager.sqf',A3XAI_directory];
};

//Set up vehicle patrols
if ((A3XAI_maxAirPatrols > 0) or {(A3XAI_maxLandPatrols > 0)}) then {
	_vehicles = [] execVM format ['%1\scripts\setup_veh_patrols.sqf',A3XAI_directory];
};

//Load custom definitions file
if (A3XAI_loadCustomFile) then {
	if (isClass (configFile >> "CfgA3XAISettings")) then {
		_customLoader = [] execVM format ["%1\init\A3XAI_custom_loader.sqf",A3XAI_directory]; //0.1.8
	} else {
		diag_log "A3XAI Error: Could not load A3XAI_config.pbo. Unable to load custom definitions.";
	};
};

//Load A3XAI server monitor
_serverMonitor = [] execVM format ['%1\scripts\A3XAI_serverMonitor.sqf',A3XAI_directory];
