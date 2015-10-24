#include "\A3XAI\globaldefines.hpp"

private["_victim","_killer","_unitGroup","_unitType","_launchWeapon","_launchAmmo","_groupIsEmpty","_unitsAlive","_vehicle","_groupSize","_newGroupSize","_fnc_deathHandler","_unitLevel","_bodyPos","_bodyPosEmpty","_collisionKilled"];

_victim = _this select 0;
_killer = _this select 1;

if (_victim getVariable ["deathhandled",false]) exitWith {};
_victim setVariable ["deathhandled",true];

_vehicle = (vehicle _victim);
_unitGroup = (group _victim);

{_victim removeAllEventHandlers _x} count ["Killed","HandleDamage","Local","Hit"];
_victim setDamage 1;
_victim removeItems FIRST_AID_ITEM_AI;
_victim removeWeapon NVG_ITEM_AI;

//Check number of units alive, preserve group immediately if empty.
_unitsAlive = ({alive _x} count (units _unitGroup));
_groupIsEmpty = if (_unitsAlive isEqualTo 0) then {_unitGroup call A3XAI_protectGroup; true} else {false};

//Retrieve group type
_unitType = _unitGroup getVariable ["unitType",""];
_unitLevel = _unitGroup getVariable ["unitLevel",0];

//Update group size counter
_groupSize = (_unitGroup getVariable ["GroupSize",0]);
if (_groupSize > 0) then {
	_newGroupSize = (_groupSize - 1);
	_unitGroup setVariable ["GroupSize",_newGroupSize];
};

_fnc_deathHandler = missionNamespace getVariable [format ["A3XAI_handleDeath_%1",_unitType],{diag_log format ["A3XAI Error: Death handler not found for unit type %1",_unitType];}];
[_victim,_killer,_unitGroup,_groupIsEmpty] call _fnc_deathHandler;
//diag_log format ["Debug: Result %1",_result];
if (_unitType in ["static","staticcustom","vehiclecrew","dynamic","random","air","aircustom","air_reinforce","land","landcustom"]) then {
	0 = [_victim,_killer,_unitGroup,_unitType,_unitsAlive] call A3XAI_handleDeath_generic;
} else {
	call {
		if (_unitType isEqualTo "aircrashed") exitWith {};
		if (_groupIsEmpty) then {
			_unitGroup setVariable ["GroupSize",-1];
			if !(isDedicated) then {
				A3XAI_updateGroupSize_PVS = [_unitGroup,-1];
				publicVariableServer "A3XAI_updateGroupSize_PVS";
			};
		};
	};
};

if !(isNull _victim) then {
	{
		if (_x in A3XAI_launcherTypes) exitWith {
			if (_x in (weapons _victim)) then {
				_victim removeWeapon _x;
			} else {
				_launcherItem = _x;
				{
					if (_launcherItem in weaponCargo _x) exitWith {
						deleteVehicle _x;
						if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Deleted WeaponHolderSimulated containing launcher %1.",_launcherItem];};
					};
				} forEach ((getPosATL _victim) nearObjects ["WeaponHolderSimulated",10]);
			};
		};
	} forEach ((_victim getVariable ["loadout",[[],[]]]) select 0);
	
	{
		if (_forEachIndex > 0) then {
			_victim removeMagazines _x;
		};
	} forEach ((_victim getVariable ["loadout",[[],[]]]) select 1);

	if (_vehicle isEqualTo (_unitGroup getVariable ["assignedVehicle",objNull])) then {
		_bodyPos = (getPosATL _victim);
		_bodyPosEmpty = _bodyPos findEmptyPosition [0,1.5,DEFAULT_UNIT_CLASSNAME];
		if (_bodyPosEmpty isEqualTo []) then {
			_victim setPosATL _bodyPos;
		} else {
			_victim setPosATL _bodyPosEmpty;
		};
		_victim setVelocity [0,0,0.25];
	};
	
	if (isPlayer _killer) then {
		_collisionKilled = _victim getVariable ["CollisionKilled",false];
		if (isDedicated) then {
			_nul = [_killer,_victim,_collisionKilled] spawn A3XAI_sendKillResponse;
		} else {
			A3XAI_sendKillResponse_PVS = [_killer,_victim,_collisionKilled];
			publicVariableServer "A3XAI_sendKillResponse_PVS";
		};
	};
	
	if (isDedicated) then {
		if ((isPlayer _killer) && {_unitGroup getVariable ["ReinforceAvailable",false]} && {(missionNamespace getVariable [format ["A3XAI_airReinforcementSpawnChance%1",_unitLevel],0]) call A3XAI_chance}) then {
			_unitGroup setVariable ["ReinforceAvailable",false];
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Group %1 (Level %2) is calling reinforcements.",_unitGroup,_unitLevel];};
			_nul = [(getPosATL _victim),_killer,_unitLevel] spawn A3XAI_spawn_reinforcement;
		};
		_victim setVariable ["A3XAI_deathTime",diag_tickTime];
	} else {
		A3XAI_registerDeath_PVS = [_victim,_killer,_unitGroup];
		publicVariableServer "A3XAI_registerDeath_PVS";
	};
	
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: %1 AI unit %2 killed by %3, %4 units left alive in group %5.",_unitType,_victim,_killer,_unitsAlive,_unitGroup];};
} else {
	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: AI unit %1 killed by %2 is null.",_victim,_killer];};
};

_victim
