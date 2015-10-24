#include "\A3XAI\globaldefines.hpp"

//Finds a position that does not have a player within a certain distance.
private ["_spawnPos","_attempts","_continue","_spawnpool","_maxAttempts"];

_attempts = 0;
_continue = true;
_spawnPos = [];
_spawnpool = +_this;
_maxAttempts = ((count _spawnpool) min 3); //3: Maximum number of attempts
while {_continue && {(_attempts < _maxAttempts)}} do {
	_index = floor (random (count _spawnpool));
	_spawnPosSelected = (getPosATL (_spawnpool select _index)) findEmptyPosition [0.5,30,SPACE_FOR_OBJECT];
	if !(_spawnPosSelected isEqualTo []) then {
		_spawnPosSelected = _spawnPosSelected isFlatEmpty [0,0,0.75,5,0,false,objNull];
	}; 
	if (
		!(_spawnPosSelected isEqualTo []) &&
		{({if ((isPlayer _x) && {([eyePos _x,[(_spawnPosSelected select 0),(_spawnPosSelected select 1),(_spawnPosSelected select 2) + 1.7],_x] call A3XAI_hasLOS) or ((_x distance _spawnPosSelected) < PLAYER_DISTANCE_NO_LOS_STATIC)}) exitWith {1}} count (_spawnPosSelected nearEntities [[PLAYER_UNITS,"LandVehicle"],PLAYER_DISTANCE_WITH_LOS_STATIC])) isEqualTo 0}
	) then {
		_spawnPos = _spawnPosSelected;
		_spawnPos set [2,0];
		_continue = false;
	} else {
		_spawnpool deleteAt _index;
		_attempts = _attempts + 1;
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Unable to find suitable spawn position. (attempt %1/%2).",_attempts,_maxAttempts];};
	};
};

_spawnPos
