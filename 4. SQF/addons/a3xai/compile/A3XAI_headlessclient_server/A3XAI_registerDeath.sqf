#include "\A3XAI\globaldefines.hpp"

private ["_victim", "_killer", "_unitGroup", "_unitLevel","_groupSize","_newGroupSize"];

_victim = _this select 0;
_killer = _this select 1;
_unitGroup = _this select 2;

_victim setVariable ["A3XAI_deathTime",diag_tickTime];
_unitLevel = (_unitGroup getVariable ["unitLevel",0]);

_groupSize = (_unitGroup getVariable ["GroupSize",0]);
if (_groupSize > 0) then {
	_newGroupSize = (_groupSize - 1);
	_unitGroup setVariable ["GroupSize",_newGroupSize];
};

if ((_unitGroup getVariable ["ReinforceAvailable",false]) && {isPlayer _killer} && {(missionNamespace getVariable [format ["A3XAI_airReinforcementSpawnChance%1",_unitLevel],0]) call A3XAI_chance}) then {
	_unitGroup setVariable ["ReinforceAvailable",false];
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Group %1 (Level %2) is calling reinforcements.",_unitGroup,_unitLevel];};
	_nul = [(getPosATL _victim),_killer,_unitLevel] spawn A3XAI_spawn_reinforcement;
};
