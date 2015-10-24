#include "\A3XAI\globaldefines.hpp"

private ["_index"];

_index = -1;
if !(isNull _this) then {
	_this setVariable ["ExileIsSimulationMonitored", true];
	_index = A3XAI_externalObjectMonitor pushBack _this;
};

_index