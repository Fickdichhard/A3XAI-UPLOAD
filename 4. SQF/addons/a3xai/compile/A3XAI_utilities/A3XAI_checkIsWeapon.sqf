#include "\A3XAI\globaldefines.hpp"

private ["_magazineTypes","_ammo","_ammoMaxRange","_ammoHit"];

if ((typeName _this) != "STRING") exitWith {false};
_magazineTypes = [configFile >> "CfgWeapons" >> _this,"magazines",[]] call BIS_fnc_returnConfigEntry;
if (_magazineTypes isEqualTo []) exitWith {false};
_cursorAim = [configFile >> "CfgWeapons" >> _this,"cursorAim","throw"] call BIS_fnc_returnConfigEntry;
if (_cursorAim isEqualTo "throw") exitWith {false};
_ammo = [configFile >> "CfgMagazines" >> (_magazineTypes select 0),"ammo",""] call BIS_fnc_returnConfigEntry;
if (_ammo isEqualTo "") exitWith {false};
_ammoHit = [configFile >> "CfgAmmo" >> _ammo,"hit",0] call BIS_fnc_returnConfigEntry;
if (_ammoHit isEqualTo 0) exitWith {false};

true