#include "\A3XAI\globaldefines.hpp"

private["_object","_hit","_damage","_source","_ammo","_hitPoint"];

_object = 		_this select 0;				//Object the event handler is assigned to. (the unit taking damage)
_hit = 			_this select 1;				//Name of the selection where the unit was damaged. "" for over-all structural damage, "?" for unknown selections. 
_damage = 		_this select 2;				//Resulting level of damage for the selection. (Received damage)
_source = 		_this select 3;				//The source unit that caused the damage. 
//_ammo = 		_this select 4;				//Classname of the projectile that caused inflicted the damage. ("" for unknown, such as falling damage.) 
_hitPartIndex = _this select 5;				//Hit part index of the hit point, -1 otherwise.

_hitPoint = (_object getHitIndex _hitPartIndex);
if (_damage > _hitPoint) then {
	call {
		if (isNull _source) exitWith {_damage = _hitPoint;}; 								//No physics damage
		if ((group _object) call A3XAI_getNoAggroStatus) exitWith {_damage = _hitPoint;};
		if ((side _source) isEqualTo A3XAI_side) exitWith {_damage = _hitPoint;};
		if (((_hit find "wheel") > -1) && {_damage > 0.8} && {!(_object getVariable ["vehicle_disabled",false])}) exitWith {
			[_object] call A3XAI_vehDestroyed;
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: AI vehicle %1 (%2) is immobilized. Respawning vehicle patrol group.",_object,(typeOf _object)];};
		};
	};
};

_damage