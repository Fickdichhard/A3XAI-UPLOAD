#include "\A3XAI\globaldefines.hpp"

private ["_unit", "_unitGroup", "_spawnPos", "_unitLevel", "_type"];
_unitGroup = _this select 0;
_unitLevel = _this select 1;
_spawnPos = _this select 2;
_antistuck = if ((count _this) > 3) then {_this select 3} else {false};

_unit = _unitGroup createUnit [DEFAULT_UNIT_CLASSNAME,_spawnPos,[],0,"FORM"];
[_unit] joinSilent _unitGroup;
0 = _unit call A3XAI_addUnitEH;
0 = [_unit, _unitLevel] call A3XAI_generateLoadout;									// Assign unit loadout
0 = [_unit, _unitLevel] call A3XAI_setSkills;										// Set AI skill
_unit enableFatigue false;
A3XAI_monitoredObjects pushBack _unit;

if (_antistuck) then {
	_unit setPosATL _spawnPos;
	_unit setVelocity [0,0,0.5];
};

if (A3XAI_debugLevel > 0) then {diag_log format["A3XAI Debug: Spawned AI %1 with unitLevel %2 for group %3.",_unit,_unitLevel,_unitGroup];};

_unit