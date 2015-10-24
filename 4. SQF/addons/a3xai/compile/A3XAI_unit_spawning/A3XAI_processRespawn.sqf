#include "\A3XAI\globaldefines.hpp"

waitUntil {uiSleep 3; diag_tickTime > A3XAI_nextRespawnTime};

A3XAI_respawnActive = true;							//First respawn is now being processed, so deny subsequent attempts to modify the initial wait time.
A3XAI_queueActive = nil;
A3XAI_nextRespawnTime = nil;

while {(count A3XAI_respawnQueue) > 0} do {
	private ["_minDelay","_delay"];

	_minDelay = -1;
	//Remove expired entries before proceeding.
	{
		if (((typeName (_x select 3)) isEqualTo "GROUP") && {(isNull (_x select 3))}) then {
			A3XAI_respawnQueue deleteAt _forEachIndex;
		};
	} forEach A3XAI_respawnQueue;

	//Begin examining queue entries.
	{
		_currentRespawn = (A3XAI_respawnQueue select _forEachIndex);
		_timeToRespawn = _currentRespawn select 0;
		//If enough time has passed to respawn the group.
		if (diag_tickTime > _timeToRespawn) then {
			_mode = _currentRespawn select 1;
			call {
				if (_mode isEqualTo 0) exitWith {
					//Infantry AI respawn
					_trigger = _currentRespawn select 2;
					_unitGroup = _currentRespawn select 3;
					_grpArray = _trigger getVariable ["GroupArray",[]];
					if ((_unitGroup in _grpArray) && {((_unitGroup getVariable ["GroupSize",0]) < 1)}) then {
						if ((triggerStatements _trigger select 1) isEqualTo "") then {
							//Trigger is active, so respawn the group
							_maxUnits = _trigger getVariable ["maxUnits",[1,0]];
							_respawned = [_unitGroup,_trigger,_maxUnits] call A3XAI_respawnGroup;
							if ((A3XAI_debugLevel > 0) && {!_respawned}) then {diag_log format ["A3XAI Debug: No units were respawned for group %1 at %2. Group %1 reinserted into respawn queue.",_unitGroup,(triggerText _trigger)];};
						} else {
							//Trigger is inactive (despawned or deleted) so clean up group instead
							if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Spawn area %1 has already been despawned. Cleaning up group %2.",triggerText _trigger,_unitGroup]};
							_unitGroup call A3XAI_deleteGroup;
							if (!isNull _trigger) then {
								_trigger setVariable ["GroupArray",_grpArray - [grpNull]];
							};
						};
					};
				};
				if (_mode isEqualTo 1) exitWith {
					//Custom vehicle AI respawn
					_respawnParams = _currentRespawn select 2;
					_nul = _respawnParams spawn A3XAI_spawnVehicleCustom;
					if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Respawning custom AI vehicle patrol with params %1",((A3XAI_respawnQueue select _forEachIndex) select 2)]};
				};
				if (_mode isEqualTo 2) exitWith {
					//Vehicle AI patrol respawn
					_vehicleTypeOld = _currentRespawn select 2;
					if (_vehicleTypeOld isKindOf "Air") then { //Air-type vehicle AI patrol respawn
						A3XAI_heliTypesUsable pushBack _vehicleTypeOld;
						_index = floor (random (count A3XAI_heliTypesUsable));
						_vehicleTypeNew = A3XAI_heliTypesUsable select _index;
						_nul = _vehicleTypeNew spawn A3XAI_spawnVehiclePatrol;
						A3XAI_heliTypesUsable deleteAt _index;
						if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Respawning AI air vehicle type patrol %1.",_vehicleTypeNew]};
					} else {
						if (_vehicleTypeOld isKindOf "LandVehicle") then { //Land-type vehicle AI patrol respawn
							A3XAI_vehTypesUsable pushBack _vehicleTypeOld;
							_index = floor (random (count A3XAI_vehTypesUsable));
							_vehicleTypeNew = A3XAI_vehTypesUsable select _index;	
							_nul = _vehicleTypeNew spawn A3XAI_spawnVehiclePatrol;
							A3XAI_vehTypesUsable deleteAt _index;
							if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Respawning AI land vehicle patrol type %1.",_vehicleTypeNew]};
						};
					};
				};
				if (_mode isEqualTo 3) exitWith {
					//UAV/UGV respawn
					_vehicleTypeOld = _currentRespawn select 2;
					if (_vehicleTypeOld isKindOf "Air") then {
						A3XAI_UAVTypesUsable pushBack _vehicleTypeOld;
						_index = floor (random (count A3XAI_UAVTypesUsable));
						_vehicleTypeNew = A3XAI_UAVTypesUsable select _index;
						_nul = _vehicleTypeNew spawn A3XAI_spawn_UV_patrol;
						A3XAI_UAVTypesUsable deleteAt _index;
						if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Respawning UAV patrol %1.",_vehicleTypeNew]};
					} else {
						if (_vehicleTypeOld isKindOf "LandVehicle") then {
							A3XAI_UGVTypesUsable pushBack _vehicleTypeOld;
							_index = floor (random (count A3XAI_UGVTypesUsable));
							_vehicleTypeNew = A3XAI_UGVTypesUsable select _index;	
							_nul = _vehicleTypeNew spawn A3XAI_spawn_UV_patrol;
							A3XAI_UGVTypesUsable deleteAt _index;
							if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Respawning UGV patrol type %1.",_vehicleTypeNew]};
						};
					};
				};
			};
			A3XAI_respawnQueue deleteAt _forEachIndex;
			uiSleep TIME_PER_RESPAWN_PROCESSING;
		} else {
			//Find shortest delay to next group respawn.
			_delay = ((_timeToRespawn - diag_tickTime) max TIME_PER_RESPAWN_PROCESSING);
			//diag_log format ["DEBUG :: Comparing new respawn time %1 with previous %2.",_delay,_minDelay];
			if (_minDelay > 0) then {
				//If next delay time is smaller than the current minimum delay, use it instead.
				if (_delay < _minDelay) then {
					_minDelay = _delay;
					//diag_log format ["DEBUG :: Found shorter respawn interval: %1 seconds.",_minDelay];
				};
			} else {
				//Initialize minimum delay to first found delay.
				_minDelay = _delay;
				//diag_log format ["DEBUG :: Set respawn interval to %1 seconds.",_minDelay];
			};
		};
	} forEach A3XAI_respawnQueue;
	if (_minDelay > -1) then {
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: %1 groups left in respawn queue. Next group is scheduled to respawn in %2 seconds.",(count A3XAI_respawnQueue),_minDelay];};
		uiSleep _minDelay;
	};
};

A3XAI_respawnActive = nil;
if (A3XAI_debugLevel > 0) then {diag_log "A3XAI Debug: Respawn queue is empty. Exiting respawn handler. (respawnHandler)";};
