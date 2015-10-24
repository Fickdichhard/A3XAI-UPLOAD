#include "\A3XAI\globaldefines.hpp"

private ["_unitType"];

_unitType = _this;

call {
	if (_unitType in ["static","staticcustom","vehiclecrew","aircustom","landcustom"]) exitWith {ANTISTUCK_CHECK_TIME_INFANTRY};
	if (_unitType in ["air","uav"]) exitWith {ANTISTUCK_CHECK_TIME_AIR};
	if (_unitType in ["land","ugv"]) exitWith {ANTISTUCK_CHECK_TIME_LAND};
	300
};
