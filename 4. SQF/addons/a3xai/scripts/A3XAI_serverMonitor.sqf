#include "\A3XAI\globaldefines.hpp"

if (A3XAI_debugLevel > 0) then {diag_log "A3XAI Server Monitor will start in 60 seconds."};

//Initialize timer variables
_currentTime = diag_tickTime;
_cleanDead = _currentTime;
_monitorReport = _currentTime;
_deleteObjects = _currentTime;
_dynLocations = _currentTime;
_checkRandomSpawns = _currentTime - MONITOR_CHECK_RANDSPAWN_FREQ;
_sideCheck = _currentTime;
_playerCountTime = _currentTime - MONITOR_UPDATE_PLAYER_COUNT_FREQ;

//Setup variables
_currentPlayerCount = 0;
_lastPlayerCount = 0;
_multiplierLowPlayers = 0;
_multiplierHighPlayers = 0;
_maxSpawnChancePlayers = (A3XAI_playerCountThreshold max 1);

if (A3XAI_upwardsChanceScaling) then {
	_multiplierLowPlayers = A3XAI_chanceScalingThreshold;
	_multiplierHighPlayers = 1;
} else {
	_multiplierLowPlayers = 1;
	_multiplierHighPlayers = A3XAI_chanceScalingThreshold;
};

A3XAI_externalObjectMonitor = missionNamespace getVariable [EXTERNAL_OBJECT_MONITOR_NAME,[]];

//Local functions
_getUptime = {
	private ["_currentSec","_outSec","_outMin","_outHour"];
	_currentSec = diag_tickTime;
	_outHour = (floor (_currentSec/3600));
	_outMin = (floor ((_currentSec - (_outHour*3600))/60));
	_outSec = (floor (_currentSec - (_outHour*3600) - (_outMin*60)));
	
	_outHour = str (_outHour);
	_outMin = str (_outMin);
	_outSec = str (_outSec);
	
	if ((count _outHour) isEqualTo 1) then {_outHour = format ["0%1",_outHour];};
	if ((count _outMin) isEqualTo 1) then {_outMin = format ["0%1",_outMin];};
	if ((count _outSec) isEqualTo 1) then {_outSec = format ["0%1",_outSec];};
	
	[_outHour,_outMin,_outSec]
};

_fnc_purgeAndDelete = {
	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Purging a %1 from A3XAI_monitoredObjects.",(typeOf _this)];};
	{_this removeAllEventHandlers _x} count ["Killed","HandleDamage","GetIn","GetOut","Fired","Local","Hit"];
	_this removeAllMPEventHandlers "MPKilled"; 
	_index = A3XAI_monitoredObjects find _this;
	if (_index > -1) then {A3XAI_monitoredObjects deleteAt _index;};
	_index = A3XAI_externalObjectMonitor find _this;
	if (_index > -1) then {A3XAI_externalObjectMonitor deleteAt _index;};
	deleteVehicle _this;
	true
};

//Script handles
_cleanupMain = scriptNull;
_cleanupLocations = scriptNull;
_cleanupRandomSpawns = scriptNull;

_canKillCleanupMain = false;
_canKillCleanupLocations = false;
_canKillRandomSpawns = false;

uiSleep 60;

while {true} do {
	//Main cleanup loop
	_currentTime = diag_tickTime;
	if ((_currentTime - _cleanDead) > MONITOR_CLEANDEAD_FREQ) then {
		if (scriptDone _cleanupMain) then {
			if (_canKillCleanupMain) then {_canKillCleanupMain = false;};
			_cleanupMain = [_currentTime,_fnc_purgeAndDelete] spawn {
				_currentTime = _this select 0;
				_fnc_purgeAndDelete = _this select 1;

				//Clean abandoned AI vehicles
				{	
					call {
						if (_x isKindOf "i_survivor_F") exitWith {
							if !(alive _x) then {
								_deathTime = _x getVariable "A3XAI_deathTime";
								if (!isNil "_deathTime") then {
									if ((_currentTime - _deathTime) > A3XAI_cleanupDelay) then {
										if (({isPlayer _x} count (_x nearEntities [[PLAYER_UNITS,"Air","LandVehicle"],30])) isEqualTo 0) then {
											_x call _fnc_purgeAndDelete;
										};
									};
								} else {
									_x setVariable ["A3XAI_deathTime",_currentTime];
								};
							};
						};
						if (_x isKindOf "I_UAV_AI") exitWith {
							if !(alive _x) then {
								_x call _fnc_purgeAndDelete;
							};
						};
						if (_x isKindOf "AllVehicles") exitWith {
							_deathTime = _x getVariable "A3XAI_deathTime";
							if (!isNil "_deathTime") then {
								if ((_currentTime - _deathTime) > A3XAI_vehicleDespawnTime) then {
									if (({isPlayer _x} count (_x nearEntities [[PLAYER_UNITS,"Air","LandVehicle"],60])) isEqualTo 0) then {
										if (({alive _x} count (crew _x)) isEqualTo 0) then {
											{
												if !(alive _x) then {
													_x call _fnc_purgeAndDelete;
												};
											} forEach (crew _x);
											_x call _fnc_purgeAndDelete;
										};
									};
								};
							} else {
								if !(alive _x) then {
									_x setVariable ["A3XAI_deathTime",_currentTime];
								};
							};
						};
					};
					uiSleep 0.025;
				} count A3XAI_monitoredObjects;
			};
		} else {
			if (_canKillCleanupMain) then {
				terminate _cleanupMain; 
				diag_log "A3XAI terminated previous cleanupMain thread.";
			} else {
				_canKillCleanupMain = true;
				diag_log "A3XAI marked current cleanupMain thread for termination.";
			};
		};
		_cleanDead = _currentTime;
	};

	//Main location cleanup loop
	if ((_currentTime - _dynLocations) > MONITOR_LOCATIONCLEANUP_FREQ) then {
		if (scriptDone _cleanupLocations) then {
			if (_canKillCleanupLocations) then {_canKillCleanupLocations = false;};
			_cleanupLocations  = [_currentTime] spawn {
				_currentTime = _this select 0;
				A3XAI_areaBlacklists = A3XAI_areaBlacklists - [locationNull];
				{
					_deletetime = _x getVariable "deletetime"; 
					if (isNil "_deleteTime") then {_deleteTime = _currentTime}; //since _x getVariable ["deletetime",_currentTime] gives an error...
					//diag_log format ["DEBUG: CurrentTime: %1. Delete Time: %2",_currentTime,_deletetime];
					if (_currentTime > _deletetime) then {
						deleteLocation _x;
						A3XAI_areaBlacklists deleteAt _forEachIndex;
					};
					uiSleep 0.025;
				} forEach A3XAI_areaBlacklists;
			};
		} else {
			if (_canKillCleanupLocations) then {
				terminate _cleanupLocations; 
				diag_log "A3XAI terminated previous cleanupLocations thread.";
			} else {
				_canKillCleanupLocations = true;
				diag_log "A3XAI marked current cleanupLocations thread for termination.";
			};
		};
		_dynLocations = _currentTime;
	};

	if ((_currentTime - _checkRandomSpawns) > MONITOR_CHECK_RANDSPAWN_FREQ) then {
		if (scriptDone _cleanupRandomSpawns) then {
			if (_canKillRandomSpawns) then {_canKillRandomSpawns = false;};
			_cleanupRandomSpawns = [_currentTime] spawn {
				_currentTime = _this select 0;
				A3XAI_randTriggerArray = A3XAI_randTriggerArray - [objNull];
				{
					if ((((triggerStatements _x) select 1) != "") && {(_currentTime - (_x getVariable ["timestamp",_currentTime])) > RANDSPAWN_EXPIRY_TIME}) then {
						_triggerLocation = _x getVariable ["triggerLocation",locationNull];
						deleteLocation _triggerLocation;
						if (A3XAI_enableDebugMarkers) then {deleteMarker (str _x)};	
						deleteVehicle _x;
						A3XAI_randTriggerArray deleteAt _forEachIndex;
					};
					if ((_forEachIndex % 3) isEqualTo 0) then {uiSleep 0.05};
				} forEach A3XAI_randTriggerArray;
				_spawnsAvailable = A3XAI_maxRandomSpawns - (count A3XAI_randTriggerArray);
				if (_spawnsAvailable > 0) then {
					_nul = _spawnsAvailable spawn A3XAI_setup_randomspawns;
				};
			};
		} else {
			if (_canKillRandomSpawns) then {
				terminate _cleanupRandomSpawns; 
				diag_log "A3XAI terminated previous cleanupRandomSpawns thread.";
			} else {
				_canKillRandomSpawns = true;
				diag_log "A3XAI marked current cleanupRandomSpawns thread for termination.";
			};
		};
		_checkRandomSpawns = _currentTime;
	};
	
	if ((_currentTime - _playerCountTime) > MONITOR_UPDATE_PLAYER_COUNT_FREQ) then {
		_currentPlayerCount = ({alive _x} count allPlayers);
		if (A3XAI_HCIsConnected) then {_currentPlayerCount = _currentPlayerCount - 1};
		if !(_lastPlayerCount isEqualTo _currentPlayerCount) then {
			A3XAI_spawnChanceMultiplier = linearConversion [1, _maxSpawnChancePlayers, _currentPlayerCount, _multiplierLowPlayers, _multiplierHighPlayers, true];
			_lastPlayerCount = _currentPlayerCount;
			if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Updated A3XAI_spawnChanceMultiplier to %1",A3XAI_spawnChanceMultiplier];};
		};
		_playerCountTime = _currentTime;
	};
	
	//Check for unwanted side modifications
	if ((_currentTime - _sideCheck) > SIDECHECK_TIME) then {
		if !((PLAYER_GROUP_SIDE getFriend A3XAI_side) isEqualTo 0) then {PLAYER_GROUP_SIDE setFriend [A3XAI_side, 0]};
		if !((A3XAI_side getFriend PLAYER_GROUP_SIDE) isEqualTo 0) then {A3XAI_side setFriend [PLAYER_GROUP_SIDE, 0]};
		if !((A3XAI_side getFriend A3XAI_side) isEqualTo 1) then {A3XAI_side setFriend [A3XAI_side, 1]};
		_sideCheck = _currentTime;
	};
	
	if (A3XAI_enableDebugMarkers) then {
		{
			if (_x in allMapMarkers) then {
				_x setMarkerPos (getMarkerPos _x);
			} else {
				A3XAI_mapMarkerArray set [_forEachIndex,""];
			};
			if ((_forEachIndex % 3) isEqualTo 0) then {uiSleep 0.05};
		} forEach A3XAI_mapMarkerArray;
		A3XAI_mapMarkerArray = A3XAI_mapMarkerArray - [""];
	};
	
	A3XAI_activeGroups = A3XAI_activeGroups - [grpNull];
	_activeGroupAmount = format ["%1/%2",{(_x getVariable ["GroupSize",0]) > 0} count A3XAI_activeGroups,count A3XAI_activeGroups];
	if (A3XAI_debugLevel > 1) then {
		_allAIGroups = format [" (Total: %1)",{(side _x) isEqualTo A3XAI_side} count allGroups];
		_activeGroupAmount = _activeGroupAmount + _allAIGroups;
	};
	
	//Report statistics to RPT log
	if ((A3XAI_monitorReportRate > 0) && {((_currentTime - _monitorReport) > A3XAI_monitorReportRate)}) then {
		_uptime = [] call _getUptime;
		diag_log format ["[A3XAI Monitor] [Uptime:%1:%2:%3][FPS:%4][Groups:%5][Respawn:%6][HC:%7]",_uptime select 0, _uptime select 1, _uptime select 2,round diag_fps,_activeGroupAmount,(count A3XAI_respawnQueue),A3XAI_HCIsConnected];
		diag_log format ["[A3XAI Monitor] [Static:%1][Dynamic:%2][Random:%3][Air:%4][Land:%5][UAV:%6][UGV:%7]",(count A3XAI_staticTriggerArray),(count A3XAI_dynTriggerArray),(count A3XAI_randTriggerArray),A3XAI_curHeliPatrols,A3XAI_curLandPatrols,A3XAI_curUAVPatrols,A3XAI_curUGVPatrols];
		_monitorReport = _currentTime;
	};

	uiSleep 30;
};
