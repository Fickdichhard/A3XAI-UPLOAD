#include "\A3XAI\globaldefines.hpp"

private ["_unitType", "_unitGroup", "_loadout", "_weapon", "_magazine", "_useLaunchers", "_maxLaunchers", "_unitLevel", "_launchWeapon", "_launchAmmo", "_useGL"];

_unitGroup = _this select 0;
_unitType = _this select 1;
_unitLevel = _this select 2;

if !(_unitType in ["uav","ugv"]) then {
	_useGL = if !(A3XAI_levelRequiredGL isEqualTo -1) then {_unitLevel >= A3XAI_levelRequiredGL} else {false};
	{
		_x setVariable ["loadout",[[],[]]];
		_loadout = _x getVariable "loadout";
		_primaryWeapon = primaryWeapon _x;
		_secondaryWeapon = secondaryWeapon _x;
		_handgunWeapon = handgunWeapon _x;
		
		if !(_primaryWeapon isEqualTo "") then {
			(_loadout select 0) pushBack _primaryWeapon;
			_primaryWeaponMagazine = getArray (configFile >> "CfgWeapons" >> _primaryWeapon >> "magazines") select 0;
			(_loadout select 1) pushBack _primaryWeaponMagazine;
		} else {
			if !(_handgunWeapon isEqualTo "") then {
				(_loadout select 0) pushBack _handgunWeapon;
				_handgunWeaponMagazine = getArray (configFile >> "CfgWeapons" >> _handgunWeapon >> "magazines") select 0;
				(_loadout select 1) pushBack _handgunWeaponMagazine;
			};
		};
		
		if !(_secondaryWeapon isEqualTo "") then {
			(_loadout select 0) pushBack _secondaryWeapon;
			_secondaryWeaponMagazine = getArray (configFile >> "CfgWeapons" >> _secondaryWeapon >> "magazines") select 0;
			(_loadout select 1) pushBack _secondaryWeaponMagazine;
		};
		
		if ((getNumber (configFile >> "CfgMagazines" >> ((_loadout select 1) select 0) >> "count")) < 6) then {_x setVariable ["extraMag",true]};
	
		if (_useGL) then {
			_weaponMuzzles = getArray(configFile >> "cfgWeapons" >> ((_loadout select 0) select 0) >> "muzzles");
			if ((count _weaponMuzzles) > 1) then {
				_GLWeapon = _weaponMuzzles select 1;
				_GLMagazines = (getArray (configFile >> "CfgWeapons" >> ((_loadout select 0) select 0) >> _GLWeapon >> "magazines"));
				if (GRENADE_AMMO_3RND in _GLMagazines) then {
					(_loadout select 0) pushBack _GLWeapon;
					(_loadout select 1) pushBack GRENADE_AMMO_3RND;
					if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Modified unit %1 loadout to %2.",_x,_loadout];};
				} else {
					if (GRENADE_AMMO_1RND in _GLMagazines) then {
						(_loadout select 0) pushBack _GLWeapon;
						(_loadout select 1) pushBack GRENADE_AMMO_1RND;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Modified unit %1 loadout to %2.",_x,_loadout];};
					}
				};
			};
		};
		
		if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: %1 Unit %2 loadout: %3. unitLevel %4.",_unitType,_x,_x getVariable ["loadout",[]],_unitLevel];};
	} forEach (units _unitGroup);
};

true