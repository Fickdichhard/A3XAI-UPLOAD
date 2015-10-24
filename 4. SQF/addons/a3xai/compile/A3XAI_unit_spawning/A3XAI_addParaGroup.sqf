#include "\A3XAI\globaldefines.hpp"

private ["_targetPlayer", "_vehicle", "_startPos", "_unitLevel", "_unitGroup", "_paraGroup", "_cargoAvailable", "_unit", "_vehiclePos", "_parachute", "_unitsAlive", "_trigger", "_rearm", "_cargoAvailable"];
	
_vehicle = _this select 0;
_unitGroup = _this select 1;
_cargoAvailable = _this select 2;
_targetPlayer = _this select 3;

_target = if (isPlayer _targetPlayer) then {_targetPlayer} else {_vehicle};
_startPos = getPosATL _target;
_startPos set [2,0];

_unitLevel = _unitGroup getVariable ["unitLevel",1];
_paraGroup = ["vehiclecrew"] call A3XAI_createGroup;

for "_i" from 1 to _cargoAvailable do {
	_unit = [_paraGroup,_unitLevel,[0,0,0]] call A3XAI_createUnit;
	_vehiclePos = (getPosATL _vehicle);
	_parachute = createVehicle [PARACHUTE_OBJECT, [_vehiclePos select 0, _vehiclePos select 1, (_vehiclePos select 2)], [], (-10 + (random 10)), "FLY"];
	_unit moveInDriver _parachute;
	_unit call A3XAI_addTempNVG;
};

_unitsAlive = {alive _x} count (units _paraGroup);
_trigger = createTrigger [TRIGGER_OBJECT,_startPos,false];
_trigger setTriggerArea [TRIGGER_SIZE_SMALL,TRIGGER_SIZE_SMALL,0,false];
_trigger setTriggerActivation ["ANY", "PRESENT", true];
_trigger setTriggerTimeout [TRIGGER_TIMEOUT_PARAGROUP, true];
_trigger setTriggerText (format ["Heli AI Reinforcement %1",mapGridPosition _vehicle]);
_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;","","0 = [thisTrigger] spawn A3XAI_despawn_static;"];
0 = [5,_trigger,[_unitGroup],PATROL_DIST_PARAGROUP,_unitLevel,[_unitsAlive,0]] call A3XAI_initializeTrigger;

_paraGroup setVariable ["GroupSize",_unitsAlive];
_paraGroup setVariable ["trigger",_trigger];

[_trigger,"A3XAI_staticTriggerArray"] call A3XAI_updateSpawnCount;
0 = [_trigger] spawn A3XAI_despawn_static;

[_paraGroup,_startPos] call A3XAI_setFirstWPPos;
0 = [_paraGroup,_startPos,PATROL_DIST_PARAGROUP] spawn A3XAI_BIN_taskPatrol;
_rearm = [_paraGroup,_unitLevel] spawn A3XAI_addGroupManager;

if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Paradrop group %1 with %2 units deployed at %3 by %4 group %5.",_paraGroup,_cargoAvailable,_startPos,typeOf _vehicle,_unitGroup];};

true