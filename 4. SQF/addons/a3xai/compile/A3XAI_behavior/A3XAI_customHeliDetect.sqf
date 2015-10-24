#include "\A3XAI\globaldefines.hpp"

private ["_detectOrigin", "_vehicle", "_detected", "_unitGroup", "_heliAimPos", "_playerAimPos"];

_vehicle = _this select 0;
_unitGroup = _this select 1;

if (_unitGroup getVariable ["IsDetecting",false]) exitWith {};
_unitGroup setVariable ["IsDetecting",true];

uiSleep (round (random 20));

if (!(_vehicle getVariable ["vehicle_disabled",false]) && {(_unitGroup getVariable ["GroupSize",-1]) > 0} && {local _unitGroup}) then{
	_detectOrigin = [getPosATL _vehicle,0,getDir _vehicle,1] call A3XAI_SHK_pos;
	_detectOrigin set [2,0];
	_detected = _detectOrigin nearEntities [[PLAYER_UNITS],DETECT_RANGE_AIR_CUSTOM];
	if ((count _detected) > 5) then {_detected resize 5};
	{
		if ((isPlayer _x) && {(_unitGroup knowsAbout _x) < 2}) then {
			_heliAimPos = aimPos _vehicle;
			_playerAimPos = aimPos _x;
			if (((lineIntersectsSurfaces [_heliAimPos,_playerEyePos,_vehicle,_x,true,1]) isEqualTo []) && {A3XAI_airDetectChance call A3XAI_chance}) then {
			//if (!(terrainIntersectASL [_heliAimPos,_playerAimPos]) && {!(lineIntersects [_heliAimPos,_playerAimPos,_vehicle,_x])} && {A3XAI_airDetectChance call A3XAI_chance}) then { //if no intersection of terrain and objects between helicopter and player, then reveal player
				_unitGroup reveal [_x,2.5];
				if (({if (RADIO_ITEM in (assignedItems _x)) exitWith {1}} count (units (group _x))) > 0) then {
					[_x,[31+(floor (random 5)),[name (leader _unitGroup)]]] call A3XAI_radioSend;
				};
			};
		};
		uiSleep 0.1;
	} forEach _detected;
};

_unitGroup setVariable ["IsDetecting",false];
