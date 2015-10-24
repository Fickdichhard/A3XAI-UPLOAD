#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_unitLevel", "_vehicle", "_maxGunners", "_vehicleTurrets", "_maxGunnersAssigned", "_gunnersAdded", "_turretWeapons", "_turretMagazines", "_gunner"];

_unitGroup = _this select 0;
_unitLevel = _this select 1;
_vehicle = _this select 2;
_maxGunners = _this select 3;

_vehicleTurrets = allTurrets [_vehicle,false];
_maxGunnersAssigned = (_maxGunners min (count _vehicleTurrets));
_gunnersAdded = 0;

{
	if (_gunnersAdded isEqualTo _maxGunnersAssigned) exitWith {};
	_turretWeapons = _vehicle weaponsTurret _x;
	if !(_turretWeapons isEqualTo []) then {
		_turretMagazines = _vehicle magazinesTurret _x;
		if !(_turretMagazines isEqualTo []) then {
			_gunner = [_unitGroup,_unitLevel,[0,0,0]] call A3XAI_createUnit;
			_gunner call A3XAI_addTempNVG;
			_gunner assignAsTurret [_vehicle,_x];
			_gunner moveInTurret [_vehicle,_x];
			_gunnersAdded = _gunnersAdded + 1;
			if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Added gunner unit %1 to %2 %3 with weapon %4 (%5 of %6).",_gunner,_unitGroup,(typeOf _vehicle),(_turretWeapons select 0),_gunnersAdded,_maxGunnersAssigned];};
		};
	};
} count _vehicleTurrets;

_gunnersAdded
