#include "\A3XAI\globaldefines.hpp"

private ["_unit", "_unitGroup", "_spawnPos", "_unitLevel", "_type"];
_unitGroup = _this select 0;
_unitLevel = _this select 1;
_spawnPos = _this select 2;

_unit = _unitGroup createUnit ["I_UAV_AI",_spawnPos,[],0,"FORM"];
[_unit] joinSilent _unitGroup;
0 = _unit call A3XAI_addUVUnitEH;
0 = [_unit, _unitLevel] call A3XAI_setSkills;										// Set AI skill
A3XAI_monitoredObjects pushBack _unit;

if (A3XAI_debugLevel > 1) then {diag_log format["A3XAI Debug: Spawned UAV AI %1 with unitLevel %2 for group %3.",_unit,_unitLevel,_unitGroup];};

_unit