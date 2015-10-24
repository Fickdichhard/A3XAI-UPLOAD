#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_unitLevel", "_trigger", "_unitType", "_groupSize"];

_unitGroup = _this;

//_unitLevel = _unitGroup getVariable ["unitLevel",1];
//_trigger = _unitGroup getVariable ["trigger",objNull];
//_unitType = _unitGroup getVariable ["unitType","unknown"];
//_groupSize = _unitGroup getVariable ["GroupSize",-1];

{
	_x call A3XAI_addUnitEH;
} forEach (units _unitGroup);

_unitGroup call A3XAI_requestGroupVars;

//diag_log format ["Debug: Group %1 (Level: %2): %3, %4, %5",_unitGroup,_unitLevel,_trigger,_unitType,_groupSize];

true