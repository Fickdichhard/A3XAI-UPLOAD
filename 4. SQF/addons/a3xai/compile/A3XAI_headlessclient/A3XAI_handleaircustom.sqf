#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_unitLevel", "_trigger", "_unitType", "_groupSize","_patrolParams"];

_unitGroup = _this;

//_unitLevel = _unitGroup getVariable ["unitLevel",1];
//_trigger = _unitGroup getVariable ["trigger",objNull];
//_unitType = _unitGroup getVariable ["unitType","unknown"];
//_groupSize = _unitGroup getVariable ["GroupSize",-1];

{
	_x call A3XAI_addUnitEH;
} forEach (units _unitGroup);

_vehicle = _unitGroup getVariable ["assignedVehicle",assignedVehicle (leader _unitGroup)];
(assignedDriver _vehicle) setVariable ["isDriver",true];
_vehicle call A3XAI_addVehAirEH;
_vehicle call A3XAI_secureVehicle;
_vehicle setVariable ["unitGroup",_unitGroup];

//if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Group %1 (Level: %2): %3, %4, %5, %6",_unitGroup,_unitLevel,_vehicle,(assignedDriver _vehicle),_unitType,_groupSize];};

true