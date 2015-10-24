#include "\A3XAI\globaldefines.hpp"

if (A3XAI_debugLevel > 0) then {diag_log "Starting A3XAI Dynamic Spawn Manager in 1 minute.";};
uiSleep 60;
//uiSleep 30; //FOR DEBUGGING
if (A3XAI_debugLevel > 0) then {diag_log "A3XAI V3 Dynamic Spawn Manager started.";};

//Spawn manager database variables
_playerUID_DB = [];			//Database of all collected playerUIDs
_lastSpawned_DB = [];		//Database of timestamps for each corresponding playerUID
_lastOnline_DB = [];		//Database of last online checks

while {true} do {
	if (({alive _x} count allPlayers) > 0) then {
		_allPlayers = [];		//Do not edit
		_currentTime = diag_tickTime;
		{
			if ((isPlayer _x) && {((typeOf _x) in [PLAYER_UNITS])}) then {
				_playerUID = getPlayerUID _x;
				if !((_playerUID select [0,2]) isEqualTo "HC") then {
					_playerIndex = _playerUID_DB find _playerUID;
					if (_playerIndex > -1) then {
						_lastSpawned = _lastSpawned_DB select _playerIndex;
						_timePassed = (_currentTime - _lastSpawned);
						if (_timePassed > A3XAI_timePerDynamicSpawn) then {
							if ((_currentTime - (_lastOnline_DB select _playerIndex)) < A3XAI_purgeLastDynamicSpawnTime) then {
								_allPlayers pushBack _x;
								//diag_log format ["DEBUG: Player %1 added to current cycle dynamic spawn list.",_x];
							};
							_lastOnline_DB set [_playerIndex,_currentTime];
						} else {
							if (_playerUID in A3XAI_failedDynamicSpawns) then {
								_allPlayers pushBack _x;
								//diag_log format ["DEBUG: Player %1 added to current cycle dynamic spawn list.",_x];
								A3XAI_failedDynamicSpawns = A3XAI_failedDynamicSpawns - [_playerUID];
							};
						};
					} else {
						_playerUID_DB pushBack _playerUID;
						_lastSpawned_DB pushBack _currentTime - DYNSPAWNMGR_SLEEP_DELAY;
						_lastOnline_DB pushBack _currentTime;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Player %1 added to dynamic spawn playerUID database.",_x];};
					};
					//diag_log format ["DEBUG: Found a player at %1 (%2).",mapGridPosition _x,name _x];
				};
			};
			uiSleep 0.05;
		} forEach allPlayers;
		
		_activeDynamicSpawns = (count A3XAI_dynTriggerArray);
		_playerCount = (count _allPlayers);
		_maxSpawnsPossible = (_playerCount min A3XAI_maxDynamicSpawns);	//Can't have more spawns than players (doesn't count current number of dynamic spawns)
		
		if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Preparing to create %1 dynamic spawns (Players: %2, Dynamic Spawns: %3).",(_maxSpawnsPossible - _activeDynamicSpawns),_playerCount,_activeDynamicSpawns];};

		while {_allPlayers = _allPlayers - [objNull]; (((_maxSpawnsPossible - _activeDynamicSpawns) > 0) && {!(_allPlayers isEqualTo [])})} do {	//_spawns: Have we created enough spawns? _allPlayers: Are there enough players to create spawns for?
			_time = diag_tickTime;
			_player = _allPlayers call A3XAI_selectRandom;
			_playerUID = (getPlayerUID _player);
			if (alive _player) then {
				_playername = name _player;
				_index = _playerUID_DB find _playerUID;
				_playerPos = getPosATL _player;
				_spawnParams = _playerPos call A3XAI_getSpawnParams;
				_spawnChance = _spawnParams select 3;
				_chanceModifier = 1.00;
				call {
					if (_spawnChance isEqualTo 0) exitWith {};
					if (_player getVariable ["ExileIsBambi",false]) exitWith {
						_spawnChance = 0;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Player %1 is bambi. Dynamic spawn chance set to 0.",_player];};
					};
					if ((vehicle _player) isKindOf "Air") exitWith {
						_spawnChance = 0;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Player %1 is in Air vehicle. Dynamic spawn chance set to 0.",_player];};
					};
					if (({if (_playerPos in _x) exitWith {1}} count (nearestLocations [_playerPos,[BLACKLIST_OBJECT_GENERAL,BLACKLIST_OBJECT_DYNAMIC],1500])) > 0) exitWith {
						_spawnChance = 0;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Player %1 is in blacklisted area. Dynamic spawn chance set to 0.",_player];};
					};
					if !((_playerPos nearObjects [PLOTPOLE_OBJECT,PLOTPOLE_RADIUS]) isEqualTo []) exitWith {
						_spawnChance = 0;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Player %1 is near pole object. Dynamic spawn chance set to 0.",_player];};
					};
					if (currentWeapon _player isEqualTo "") then {
						_chanceModifier = _chanceModifier + DYNAMIC_CHANCE_ADJUST_UNARMED;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Player %1 is unarmed. Unadjusted dynamic spawn chance set to %2.",_player,_chanceModifier];};
					};
					if ((damage _player) > DYNAMIC_WEAK_PLAYER_HEALTH) then {
						_chanceModifier = _chanceModifier + DYNAMIC_CHANCE_ADJUST_WEAKENED;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Player %1 is weakened. Unadjusted dynamic spawn chance set to %2.",_player,_chanceModifier];};
					};
					if !((_playerPos nearObjects [LOOT_HOLDER_CLASS,DYNAMIC_LOOTING_DISTANCE]) isEqualTo []) then {
						_chanceModifier = _chanceModifier + DYNAMIC_CHANCE_ADJUST_LOOTING;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Player %1 is looting. Unadjusted dynamic spawn chance set to %2.",_player,_chanceModifier];};
					};
					if ((_player getVariable ["ExileMoney",0]) > DYNAMIC_RICH_PLAYER_AMOUNT) then {
						_chanceModifier = _chanceModifier + DYNAMIC_CHANCE_ADJUST_WEALTHY;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Player %1 is wealthy. Unadjusted dynamic spawn chance set to %2.",_player,_chanceModifier];};
					};
					if (_chanceModifier < 0) then {_chanceModifier = 0;};
					if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Dynamic spawn probabilities for %1: Base: %2, Modifier: %3, A3XAI_spawnChanceMultiplier: %4",_player,_spawnChance,_chanceModifier,A3XAI_spawnChanceMultiplier];};
					_spawnChance = (_spawnChance * _chanceModifier * A3XAI_spawnChanceMultiplier);
				};
				if (_spawnChance call A3XAI_chance) then {
					_lastSpawned_DB set [_index,diag_tickTime];
					_trigger = createTrigger [TRIGGER_OBJECT,_playerPos,false];
					_location = [_playerPos,TEMP_BLACKLIST_AREA_DYNAMIC_SIZE] call A3XAI_createBlackListAreaDynamic;
					_trigger setVariable ["triggerLocation",_location];
					_trigger setTriggerArea [TRIGGER_SIZE_SMALL,TRIGGER_SIZE_SMALL,0,false];
					_trigger setTriggerActivation ["ANY", "PRESENT", true];
					_trigger setTriggerTimeout [TRIGGER_TIMEOUT_DYNAMIC, true];
					_trigger setTriggerText (format ["Dynamic Spawn (Triggered by: %1)",_playername]);
					_trigger setVariable ["targetplayer",_player];
					_trigger setVariable ["targetplayerUID",_playerUID];
					_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;","", "[thisTrigger] spawn A3XAI_despawn_dynamic;"];
					if (A3XAI_enableDebugMarkers) then {
						_nul = _trigger spawn {
							_marker = str(_this);
							if (_marker in allMapMarkers) then {deleteMarker _marker};
							_marker = createMarker[_marker,(getPosASL _this)];
							_marker setMarkerShape "ELLIPSE";
							_marker setMarkerType "Flag";
							_marker setMarkerBrush "SOLID";
							_marker setMarkerSize [600, 600];
							_marker setMarkerAlpha 0;
						};
					};
					0 = [PATROL_DIST_DYNAMIC,_trigger,_spawnParams select 0,_spawnParams select 1,_spawnParams select 2] call A3XAI_spawnUnits_dynamic;
					if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Created dynamic trigger at %1 with params %2. Triggered by player: %3.",(mapGridPosition _trigger),_spawnParams,_playername];};
				} else {
					if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Dynamic spawn probability check failed for player %1 (Probability: %2).",_playername,_spawnChance];};
				};
			} else {
				if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Cancel dynamic spawn check for player %1 (Reason: Player not in suitable state).",_player]};
			};
			_allPlayers = _allPlayers - [_player];
			_activeDynamicSpawns = _activeDynamicSpawns + 1;
			if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Processed a spawning probability check in %1 seconds.",diag_tickTime - _time]};
			uiSleep 5;
		};
	} else {
		if (A3XAI_debugLevel > 1) then {diag_log "A3XAI Debug: No players online. Dynamic spawn manager is entering waiting state.";};
	};

	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Dynamic spawn manager is sleeping for %1 seconds.",DYNSPAWNMGR_SLEEP_DELAY];};
	uiSleep DYNSPAWNMGR_SLEEP_DELAY;
};
