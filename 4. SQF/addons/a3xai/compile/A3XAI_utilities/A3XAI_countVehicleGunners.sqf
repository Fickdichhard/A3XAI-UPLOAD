#include "\A3XAI\globaldefines.hpp"

private ["_vehicle", "_gunnerCount"];

_vehicle = _this;

_gunnerCount = {!((_vehicle weaponsTurret _x) isEqualTo []) && {!((_vehicle magazinesTurret _x) isEqualTo [])}} count (allTurrets [_vehicle,false]);

diag_log format ["Debug: %1 has %2 gunners.",(typeOf _vehicle),_gunnerCount];

_gunnerCount