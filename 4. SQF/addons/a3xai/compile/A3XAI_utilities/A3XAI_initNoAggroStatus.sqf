#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_object", "_inArea", "_noAggroRange","_leader","_assignedTarget"];

_unitGroup = _this;
_object = (leader _unitGroup);

_noAggroRange = call {
	private ["_unitType"];
	_unitType = _unitGroup getVariable ["unitType",""];
	if (_unitType isEqualTo "static") exitWith {NO_AGGRO_RANGE_MAN};
	if (_unitType isEqualTo "random") exitWith {NO_AGGRO_RANGE_MAN};
	if (_unitType isEqualTo "dynamic") exitWith {NO_AGGRO_RANGE_MAN};
	if (_unitType isEqualTo "air") exitWith {NO_AGGRO_RANGE_AIR};
	if (_unitType isEqualTo "land") exitWith {NO_AGGRO_RANGE_LAND};
	if (_unitType isEqualTo "uav") exitWith {NO_AGGRO_RANGE_UAV};
	if (_unitType isEqualTo "ugv") exitWith {NO_AGGRO_RANGE_UGV};
	if (_unitType isEqualTo "air_reinforce") exitWith {NO_AGGRO_RANGE_AIR};
	if (_unitType isEqualTo "vehiclecrew") exitWith {NO_AGGRO_RANGE_MAN};
	if (_unitType isEqualTo "staticcustom") exitWith {NO_AGGRO_RANGE_MAN};
	if (_unitType isEqualTo "aircustom") exitWith {NO_AGGRO_RANGE_AIR};
	if (_unitType isEqualTo "landcustom") exitWith {NO_AGGRO_RANGE_LAND};
	900
};

_leader = (leader _unitGroup);
_inArea = [_object,_noAggroRange] call A3XAI_checkInNoAggroArea; //need to set range according to unit type.

if !(_inArea) then {
	_assignedTarget = (assignedTarget (vehicle _leader));
	if ((_assignedTarget distance _leader) < _noAggroRange) then {	//900: replace with engagement range
		_inArea = [_assignedTarget,300] call A3XAI_checkInNoAggroArea;
	};
};

[_unitGroup,_inArea] call A3XAI_setNoAggroStatus;

true
