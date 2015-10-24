#include "\A3XAI\globaldefines.hpp"

private["_trigger"];
_trigger = _this;

A3XAI_dynTriggerArray = A3XAI_dynTriggerArray - [_trigger];
_playerUID = _trigger getVariable "targetplayerUID";
if (!isNil "_playerUID") then {A3XAI_failedDynamicSpawns pushBack _playerUID};
if (A3XAI_enableDebugMarkers) then {deleteMarker str(_trigger)};

deleteVehicle _trigger;

false
