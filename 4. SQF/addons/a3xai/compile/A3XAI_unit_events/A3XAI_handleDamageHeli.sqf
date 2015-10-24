#include "\A3XAI\globaldefines.hpp"

private["_object","_hit","_damage","_source","_ammo","_partdamage","_durability","_objectGroup","_currentDamage","_hitPoint"];

_object = 		_this select 0;				//Object the event handler is assigned to. (the unit taking damage)
_hit = 			_this select 1;				//Name of the selection where the unit was damaged. "" for over-all structural damage, "?" for unknown selections. 
_damage = 		_this select 2;				//Resulting level of damage for the selection. (Received damage)
_source = 		_this select 3;				//The source unit that caused the damage. 
_ammo = 		_this select 4;				//Classname of the projectile that caused inflicted the damage. ("" for unknown, such as falling damage.) 
_hitPartIndex = _this select 5;				//Hit part index of the hit point, -1 otherwise.

_hitPoint = (_object getHitIndex _hitPartIndex);
if (_damage > _hitPoint) then {
	if (isNull _source) exitWith {_damage = _hitPoint;}; 								//No physics damage
	if ((group _object) call A3XAI_getNoAggroStatus) exitWith {_damage = _hitPoint;};

	_durability = _object getVariable "durability";
	if (isNil "_durability") then {
		_object setVariable ["durability",[0,0,0,0]];
		_durability = _object getVariable "durability";
	};

	if ((side _source) != A3XAI_side) then {
		_destroyed = false;
		_disabled = false;
		call {
			if (_hit isEqualTo "hull_hit") exitWith {
				//Structural damage
				_currentDamage = (_durability select 0);
				_partdamage = _currentDamage + (_damage - _currentDamage);
				_durability set [0,_partdamage];
				if ((_partdamage > 0.9) && {alive _object}) then {
					_damage = _hitPoint;
					_destroyed = true;
					_disabled = true;
				};
			};
			if (_hit in ["engine_hit","engine_1_hit","engine_2_hit","engine_3_hit","engine_4_hit"]) exitWith {
				_currentDamage = (_durability select 1);
				_partdamage =_currentDamage + (_damage - _currentDamage);
				_durability set [1,_partdamage];
				if ((_partdamage > 0.9) && {alive _object}) then {
					_damage = _hitPoint;
					_destroyed = true;
					_disabled = true;
				};
			};
			if (_hit in ["tail_rotor_hit","main_rotor_hit","main_rotor_1_hit","main_rotor_2_hit"]) exitWith {
				_currentDamage = (_durability select 2);
				_partdamage = _currentDamage + (_damage - _currentDamage);
				_durability set [2,_partdamage];
				if ((_partdamage > 0.9)&& {alive _object}) then {
					{
						_object setHit [_x,1];
					} forEach ["tail_rotor_hit","main_rotor_hit","main_rotor_1_hit","main_rotor_2_hit"];
					_destroyed = false;
					_disabled = true;
				};
			};
			if (_hit isEqualTo "fuel_hit") exitWith {_damage = _hitPoint};
		};
		if (_disabled) then {
			0 = [_object] call A3XAI_heliEvacuated; 
			//{_object removeAllEventHandlers _x} forEach ["HandleDamage","GetOut","Killed","Hit"];
			if (_destroyed) then {
				_nul = _object spawn {
					uiSleep 3;
					_this setVehicleAmmo 0;
					_this setFuel 0;
					_this setDamage 1;
				};
			};
		};
	};
};

_damage
