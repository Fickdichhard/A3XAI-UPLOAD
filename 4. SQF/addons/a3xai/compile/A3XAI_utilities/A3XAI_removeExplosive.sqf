#include "\A3XAI\globaldefines.hpp"

if ((typeName _this) != "OBJECT") exitWith {};

private ["_vehicleWeapons","_cursorAim","_missileMags","_vehicleMags","_vehicleTurrets"];

_vehicleWeapons = +(weapons _this);
_vehicleMags = +(magazines _this);
_vehicleTurrets = allTurrets [_this,false];
if !([-1] in _vehicleTurrets) then {_vehicleTurrets pushBack [-1];};

{
	private ["_ammo","_explosiveRating"];
	_ammo = [configFile >> "CfgMagazines" >> _x,"ammo",""] call BIS_fnc_returnConfigEntry;
	_explosiveRating = [configFile >> "CfgAmmo" >> _ammo,"explosive",0] call BIS_fnc_returnConfigEntry;
	if (_explosiveRating > AI_VEHICLEWEAPON_EXPLOSIVERATING_LIMIT) then {
		_this removeMagazines _x;
		if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Removed explosive magazine %1 from vehicle %2.",_x,(typeOf _this)];};
	};
} forEach _vehicleMags;

{
	private ["_currentTurret","_turretWeapons"];
	_turretWeapons = _this weaponsTurret _x;
	//diag_log format ["DEBUG WEAPONS: %1",_turretWeapons];
	_currentTurret = _x;
	{
		private ["_currentTurretWeapon","_turretMags"];
		_currentTurretWeapon = _x;
		_turretMags = _this magazinesTurret _currentTurret;
		{
			private ["_ammo","_explosiveRating"];
			_ammo = [configFile >> "CfgMagazines" >> _x,"ammo",""] call BIS_fnc_returnConfigEntry;
			_explosiveRating = [configFile >> "CfgAmmo" >> _ammo,"explosive",0] call BIS_fnc_returnConfigEntry;
			if (_explosiveRating > AI_VEHICLEWEAPON_EXPLOSIVERATING_LIMIT) then {
				_this removeMagazinesTurret [_x,_currentTurret];
				if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Removed explosive magazine %1 from vehicle %2.",_x,(typeOf _this)];};
			};
		} forEach _turretMags;
	} forEach _turretWeapons;
} forEach _vehicleTurrets;

true