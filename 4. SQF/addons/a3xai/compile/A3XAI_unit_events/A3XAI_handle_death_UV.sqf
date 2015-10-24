#include "\A3XAI\globaldefines.hpp"

private["_victim","_killer","_unitGroup","_unitType","_launchWeapon","_launchAmmo","_groupIsEmpty","_unitsAlive","_vehicle","_groupSize","_newGroupSize","_fnc_deathHandler","_unitLevel","_bodyPos","_bodyPosEmpty"];

_victim = _this select 0;
_killer = _this select 1;

if (_victim getVariable ["deathhandled",false]) exitWith {};
_victim setVariable ["deathhandled",true];

_vehicle = (vehicle _victim);
_unitGroup = (group _victim);

{_victim removeAllEventHandlers _x} count ["Killed","HandleDamage","Local","Hit"];
_victim setDamage 1;

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

if !(isNull _victim) then {	
	if (isDedicated) then {
		_victim setVariable ["A3XAI_deathTime",diag_tickTime];
	} else {
		A3XAI_registerDeath_PVS = [_victim,_killer,_unitGroup];
		publicVariableServer "A3XAI_registerDeath_PVS";
	};
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: %1 AI unit %2 killed by %3, %4 units left alive in group %5.",_unitType,_victim,_killer,_unitsAlive,_unitGroup];};
} else {
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: AI unit %1 killed by %2 is null.",_victim,_killer];};
};

_victim
