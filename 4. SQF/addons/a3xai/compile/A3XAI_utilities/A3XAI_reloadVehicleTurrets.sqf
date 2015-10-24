#include "\A3XAI\globaldefines.hpp"

private ["_vehicle","_reloadedTurrets","_vehicleTurrets"];

_vehicle = _this;

_reloadedTurrets = false;

_vehicleTurrets = allTurrets [_vehicle,false];
{
	private ["_turretWeapons","_turretMagazine","_turretAmmoCount","_turretMagazines","_turretPath"];
	_turretWeapons = _vehicle weaponsTurret _x;
	if !(_turretWeapons isEqualTo []) then {
		_turretMagazines = _vehicle magazinesTurret _x;
		_turretPath = _x;
		{
			_turretAmmoCount = _vehicle magazineTurretAmmo [_x,_turretPath];
			if (_turretAmmoCount isEqualTo 0) then {
				_vehicle removeMagazinesTurret [_x, _turretPath];
				_vehicle addMagazineTurret [_x,_turretPath];
				if !(_reloadedTurrets) then {_reloadedTurrets = true};
			};
		} forEach _turretMagazines;
	};
} forEach _vehicleTurrets;

_reloadedTurrets