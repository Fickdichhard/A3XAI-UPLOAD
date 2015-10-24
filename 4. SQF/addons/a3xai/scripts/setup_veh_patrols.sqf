#include "\A3XAI\globaldefines.hpp"

waitUntil {uiSleep 0.3; (!isNil "A3XAI_locations_ready" && {!isNil "A3XAI_classnamesVerified"})};

if (A3XAI_maxAirPatrols > 0) then {
	_nul = [] spawn {
		for "_i" from 0 to ((count A3XAI_airVehicleList) - 1) do {
			_currentElement = (A3XAI_airVehicleList select _i);
			if ((typeName _currentElement) isEqualTo "ARRAY") then {
				_heliType = _currentElement select 0;
				_amount = _currentElement select 1;
				
				if ([_heliType,"vehicle"] call A3XAI_checkClassname) then {
					for "_j" from 1 to _amount do {
						A3XAI_heliTypesUsable pushBack _heliType;
					};
				} else {
					if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: %1 attempted to spawn invalid vehicle type %2.",__FILE__,_heliType];};
				};
			} else {
				diag_log "A3XAI Error: Non-array element found in A3XAI_airVehicleList. Please see default configuration file for proper format.";
			};
		};
		
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Assembled helicopter list: %1",A3XAI_heliTypesUsable];};
		
		_maxHelis = (A3XAI_maxAirPatrols min (count A3XAI_heliTypesUsable));
		for "_i" from 1 to _maxHelis do {
			_index = floor (random (count A3XAI_heliTypesUsable));
			_heliType = A3XAI_heliTypesUsable select _index;
			_nul = _heliType spawn A3XAI_spawnVehiclePatrol;
			A3XAI_heliTypesUsable deleteAt _index;
			if (_i < _maxHelis) then {uiSleep 20};
		};
	};
	uiSleep 5;
};

if (A3XAI_maxLandPatrols > 0) then {
	_nul = [] spawn {
		for "_i" from 0 to ((count A3XAI_landVehicleList) - 1) do {
			_currentElement = (A3XAI_landVehicleList select _i);
			if ((typeName _currentElement) isEqualTo "ARRAY") then {
				_vehType = _currentElement select 0;
				_amount = _currentElement select 1;
				
				if ([_vehType,"vehicle"] call A3XAI_checkClassname) then {
					for "_j" from 1 to _amount do {
						A3XAI_vehTypesUsable pushBack _vehType;
					};
				} else {
					if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: %1 attempted to spawn invalid vehicle type %2.",__FILE__,_vehType];};
				};
			} else {
				diag_log "A3XAI Error: Non-array element found in A3XAI_landVehicleList. Please see default configuration file for proper format.";
			};
		};
		
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Assembled vehicle list: %1",A3XAI_vehTypesUsable];};
		
		_maxVehicles = (A3XAI_maxLandPatrols min (count A3XAI_vehTypesUsable));
		for "_i" from 1 to _maxVehicles do {
			_index = floor (random (count A3XAI_vehTypesUsable));
			_vehType = A3XAI_vehTypesUsable select _index;
			_nul = _vehType spawn A3XAI_spawnVehiclePatrol;
			A3XAI_vehTypesUsable deleteAt _index;
			if (_i < _maxVehicles) then {uiSleep 20};
		};
	};
};

if (A3XAI_maxUAVPatrols > 0) then {
	_nul = [] spawn {
		for "_i" from 0 to ((count A3XAI_UAVList) - 1) do {
			_currentElement = (A3XAI_UAVList select _i);
			if ((typeName _currentElement) isEqualTo "ARRAY") then {
				_vehType = _currentElement select 0;
				_amount = _currentElement select 1;
				
				if ([_vehType,"vehicle"] call A3XAI_checkClassname) then {
					for "_j" from 1 to _amount do {
						A3XAI_UAVTypesUsable pushBack _vehType;
					};
				} else {
					if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: %1 attempted to spawn invalid vehicle type %2.",__FILE__,_vehType];};
				};
			} else {
				diag_log "A3XAI Error: Non-array element found in A3XAI_UAVList. Please see default configuration file for proper format.";
			};
		};
		
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Assembled UAV list: %1",A3XAI_UAVTypesUsable];};
		
		_maxVehicles = (A3XAI_maxUAVPatrols min (count A3XAI_UAVTypesUsable));
		for "_i" from 1 to _maxVehicles do {
			_index = floor (random (count A3XAI_UAVTypesUsable));
			_vehType = A3XAI_UAVTypesUsable select _index;
			_vehicleClass = [configFile >> "CfgVehicles" >> _vehType,"vehicleClass",""] call BIS_fnc_returnConfigEntry;
			_nul = _vehType spawn A3XAI_spawn_UV_patrol;
			A3XAI_UAVTypesUsable deleteAt _index;
			if (_i < _maxVehicles) then {uiSleep 20};
		};
	};
};

if (A3XAI_maxUGVPatrols > 0) then {
	_nul = [] spawn {
		for "_i" from 0 to ((count A3XAI_UGVList) - 1) do {
			_currentElement = (A3XAI_UGVList select _i);
			if ((typeName _currentElement) isEqualTo "ARRAY") then {
				_vehType = _currentElement select 0;
				_amount = _currentElement select 1;
				
				if ([_vehType,"vehicle"] call A3XAI_checkClassname) then {
					for "_j" from 1 to _amount do {
						A3XAI_UGVTypesUsable pushBack _vehType;
					};
				} else {
					if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: %1 attempted to spawn invalid vehicle type %2.",__FILE__,_vehType];};
				};
			} else {
				diag_log "A3XAI Error: Non-array element found in A3XAI_UGVList. Please see default configuration file for proper format.";
			};
		};
		
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Assembled UGV list: %1",A3XAI_UGVTypesUsable];};
		
		_maxVehicles = (A3XAI_maxUGVPatrols min (count A3XAI_UGVTypesUsable));
		for "_i" from 1 to _maxVehicles do {
			_index = floor (random (count A3XAI_UGVTypesUsable));
			_vehType = A3XAI_UGVTypesUsable select _index;
			_nul = _vehType spawn A3XAI_spawn_UV_patrol;
			A3XAI_UGVTypesUsable deleteAt _index;
			if (_i < _maxVehicles) then {uiSleep 20};
		};
	};
};
