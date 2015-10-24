#include "\A3XAI\globaldefines.hpp"

if (hasInterface || isDedicated || !isNil "A3XAI_HC_isActive") exitWith {};

_startTime = diag_tickTime;

A3XAI_HC_isActive = true;
A3XAI_directory = "A3XAI";
A3XAI_HCPlayerLoggedIn = false;
A3XAI_HCGroupsCount = 0;
A3XAI_enableHC = true;
A3XAI_settingsReady = false;

//Create reference marker to act as boundary for spawning AI air/land vehicles.
_worldName = (toLower worldName);
_markerInfo = call {
	{
		if (_worldName isEqualTo (_x select 0)) exitWith {
			[_x select 1,_x select 2]
		};
	} forEach [
		//worldName, center position, landmass radius
		["altis",[15834.2,15787.8,0],12000],
		["australia",[21966.2,22728.5,0],15000],
		["bootcamp_acr",[1938.24,1884.16,0],1800],
		["caribou",[3938.9722, 4195.7417],3500],
		["chernarus",[7652.9634, 7870.8076],5500],
		["chernarus_summer",[6669.88,9251.68,0],6000],
		["desert_e",[1034.26,1022.18,0],1000],
		["esseker",[6206.94,5920.05,0],5700],
		["fallujah",[5139.8008, 4092.6797],4000],
		["fdf_isle1_a",[10771.362, 8389.2568],2750],
		["intro",[2914.44,2771.61,0],900],
		["isladuala",[4945.3438, 4919.6616],4000],
		["lingor",[5166.5581, 5108.8301],4500],
		["mbg_celle2",[6163.52, 6220.3984],6000],
		["mountains_acr",[3223.09,3242.13,0],3100],
		["namalsk",[5880.1313, 8889.1045],3000],
		["napf",[10725.096, 9339.918],8500],
		["oring",[5191.1069, 5409.1938],4750],
		["panthera2",[5343.6953, 4366.2534],3500],
		["porto",[2641.45,2479.77,0],800],
		["sara",[12693.104, 11544.386],6250],
		["saralite",[5357.5,5000.67,0],3000],
		["sara_dbe1",[11995.3,11717.9,0],7000],
		["sauerland",[12270.443, 13632.132],17500],
		["smd_sahrani_a2",[12693.104, 11544.386],6250],
		["stratis",[3937.6,4774.51,0],3000],
		["takistan",[6368.2764, 6624.2744],6000],
		["tavi",[10887.825, 11084.657],8500],
		["trinity",[7183.8403, 7067.4727],5300],
		["utes",[3519.8037, 3703.0649],1000],
		["woodland_acr",[3884.41,3896.44,0],3700],
		["zargabad",[3917.6201, 3800.0376],2000],
		[_worldname,getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition"),worldSize/2]
	];
};
_centerMarker = createMarkerLocal ["A3XAI_centerMarker",_markerInfo select 0];
_centerMarker setMarkerSizeLocal [_markerInfo select 1,_markerInfo select 1];

_nul = [] spawn {
	_versionKey = [configFile >> "CfgPatches" >> "A3XAI_HC","A3XAI_HCVersion","0"] call BIS_fnc_returnConfigEntry;
	diag_log format ["[A3XAI] Initializing A3XAI HC build %1 using base path %2.",_versionKey,A3XAI_directory];

	A3XAI_enableDebugMarkers = (([missionConfigFile >> "CfgDeveloperOptions","enableDebugMarkers",0] call BIS_fnc_returnConfigEntry) isEqualTo 1);
	_readOverrideFile = (([missionConfigFile >> "CfgDeveloperOptions","readOverrideFile",0] call BIS_fnc_returnConfigEntry) isEqualTo 1);
	_serverDir = [missionConfigFile >> "CfgDeveloperOptions","headlessClientDir","@A3XAI_HC"] call BIS_fnc_returnConfigEntry;
	_useRemoteConfigs = (([missionConfigFile >> "CfgDeveloperOptions","useRemoteConfigs",1] call BIS_fnc_returnConfigEntry) isEqualTo 1); //Using local configs not currently supported.
	_debugLevelHC = [missionConfigFile >> "CfgDeveloperOptions","useDebugLevel",0] call BIS_fnc_returnConfigEntry;

	if ((!_useRemoteConfigs) && {!isFilePatchingEnabled}) then {_useRemoteConfigs = true;};

	diag_log "[A3XAI] Waiting for HC player object setup to be completed.";
	
	waitUntil {uiSleep 2; player == player};
	if !((typeOf player) isEqualTo "HeadlessClient_F") exitWith {
		diag_log format ["A3XAI Error: Headless client assigned to wrong player slot. Player Type: %1. Expected: HeadlessClient_F",(typeOf player)];
	};
	
	A3XAI_HCObject = player;
	A3XAI_HCObjectGroup = (group player);
	A3XAI_HCObject allowDamage false;
	
	diag_log "[A3XAI] Attempting to connect to A3XAI server...";
	A3XAI_HCLogin_PVS = [A3XAI_HCObject,_versionKey,_useRemoteConfigs]; 
	publicVariableServer "A3XAI_HCLogin_PVS";
	_loginStart = diag_tickTime;
	waitUntil {uiSleep 1; ((!isNil "A3XAI_HC_serverResponse") or {(diag_tickTime - _loginStart) > 60})};
	
	if (isNil "A3XAI_HC_serverResponse") exitWith {
		diag_log "[A3XAI] Headless client connection timed out after 60 seconds of no response from server.";
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: HC Object %1. Group %2",A3XAI_HCObject,A3XAI_HCObjectGroup];};
		{deleteVehicle _x} forEach (units A3XAI_HCObjectGroup);
		deleteGroup A3XAI_HCObjectGroup;
		endMission "END1";
	};
	
	_isConnectionRejected = call {
		_responseType = (typeName A3XAI_HC_serverResponse);
		if (_responseType == "ARRAY") exitWith {
			(A3XAI_HC_serverResponse isEqualTo [])
		};
		if (_responseType == "BOOL") exitWith {
			!(A3XAI_HC_serverResponse)
		};
		true
	};
	
	if (_isConnectionRejected) exitWith {
		diag_log "[A3XAI] Headless client connection unsuccessful. HC authorization request rejected (incorrect HC version?).";
		{deleteVehicle _x} forEach (units A3XAI_HCObjectGroup);
		deleteGroup A3XAI_HCObjectGroup;
		endMission "END1";
	};
	
	_configCheck = if (_useRemoteConfigs) then {
		call compile preprocessFileLineNumbers format ["%1\init\loadSettingsHC.sqf",A3XAI_directory]
	} else {
		//Not currently supported
	};
	if (isNil "_configCheck") exitWith {diag_log "A3XAI Critical Error: Configuration file not successfully loaded. Stopping startup procedure.";};
	
	if (_debugLevelHC > 0) then {A3XAI_debugLevel = _debugLevelHC;};
	if (_readOverrideFile && {isFilePatchingEnabled}) then {call compile preprocessFileLineNumbers format ["%1\A3XAI_settings_override.sqf",_serverDir];};
	
	diag_log "[A3XAI] Headless client connection successful. HC authorization request granted.";

	//Load internal use variables
	call compile preprocessFileLineNumbers format ["%1\init\variables.sqf",A3XAI_directory];

	//Load A3XAI functions and A3XAI HC functions
	diag_log "[A3XAI] Compiling functions...";
	_check = call compile preprocessFileLineNumbers "A3XAI\init\A3XAI_HCFunctions.sqf";
	if (isNil "_check") exitWith {diag_log "A3XAI Critical Error: HC functions not successfully loaded. Stopping startup procedure.";};
	_check = call compile preprocessFileLineNumbers "A3XAI\init\A3XAI_functions.sqf";
	if (isNil "_check") exitWith {diag_log "A3XAI Critical Error: Functions not successfully loaded. Stopping startup procedure.";};
	_check = call compile preprocessFileLineNumbers "A3XAI\init\A3XAI_HC_PVEH.sqf";
	if (isNil "_check") exitWith {diag_log "A3XAI Critical Error: PublicVariable EHs not successfully loaded. Stopping startup procedure.";};
	
	diag_log format ["[A3XAI] A3XAI HC started with Debug Level: %1.",A3XAI_debugLevel];

	//Build location list
	_setupLocations = [] execVM format ['%1\scripts\setup_locations.sqf',A3XAI_directory];
	waitUntil {uiSleep 0.5; scriptDone _setupLocations};
	
	_serverMonitor = [] execVM format ['%1\compile\A3XAI_headlessclient\A3XAI_HCMonitor.sqf',A3XAI_directory];
};
