#include "\A3XAI\globaldefines.hpp"

if !(isServer) exitWith {false};

private ["_vehicle"];

_vehicle = _this;

if !(isServer) exitWith {false};
if (isNull _vehicle) exitWith {};

_vehicle setVariable ["A3XAI_deathTime",diag_tickTime];

true
