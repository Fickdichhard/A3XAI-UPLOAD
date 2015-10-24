#include "\A3XAI\globaldefines.hpp"

private ["_objectMonitor","_object","_index"];
_object = _this;

_index = A3XAI_monitoredObjects pushBack _object;

_index