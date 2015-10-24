#include "\A3XAI\globaldefines.hpp"

private["_trigger","_triggerLocation"];
_trigger = _this;

[_trigger,"A3XAI_randTriggerArray"] call A3XAI_updateSpawnCount;
if (A3XAI_enableDebugMarkers) then {deleteMarker (str _trigger)};

_triggerLocation = _trigger getVariable "triggerLocation";
deleteLocation _triggerLocation;
deleteVehicle _trigger;

false
