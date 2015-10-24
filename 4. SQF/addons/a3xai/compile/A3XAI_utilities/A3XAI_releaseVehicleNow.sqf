#include "\A3XAI\globaldefines.hpp"

private ["_object"];

_object = _this;

_object removeAllEventHandlers "GetIn";
_object setVariable ["A3XAI_deathTime",nil];
_object addMPEventHandler ["MPKilled",{
	(_this select 0) call A3XAI_vehMPKilled;
}];

_object call A3XAI_addToExternalObjectMonitor;

if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Player entered AI %1 at %2. Vehicle A3XAI_deathTime variable set to nil.",(typeOf _object),(getPosATL _object)];};

true
