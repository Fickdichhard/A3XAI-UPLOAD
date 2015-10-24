#include "\A3XAI\globaldefines.hpp"

if !((typeName _this) isEqualTo "ARRAY") exitWith {diag_log format ["Error: Wrong arguments sent to %1.",__FILE__]};
if (A3XAI_customVehicleSpawnQueue isEqualTo []) then {
	A3XAI_customVehicleSpawnQueue pushBack _this;
	_vehicleQueue = [] spawn {
		while {!(A3XAI_customVehicleSpawnQueue isEqualTo [])} do {
			_vehicleType = (A3XAI_customVehicleSpawnQueue select 0) select 2;
			if (!(_vehicleType isKindOf "StaticWeapon") && {[_vehicleType,"vehicle"] call A3XAI_checkClassname}) then {
				(A3XAI_customVehicleSpawnQueue select 0) call A3XAI_spawnVehicleCustom;
			} else {
				diag_log format ["A3XAI Error: %1 attempted to spawn unsupported vehicle type %2.",__FILE__,_vehicleType];
			};
			A3XAI_customVehicleSpawnQueue deleteAt 0;
			uiSleep 2;
		};
	};
} else {
	A3XAI_customVehicleSpawnQueue pushBack _this;
};
