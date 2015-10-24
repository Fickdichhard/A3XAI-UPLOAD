#include "\A3XAI\globaldefines.hpp"

private ["_vehicle","_victim","_unitGroup","_parachuted"];

_victim = _this select 0;
_unitGroup = _this select 2;

_vehicle = (_unitGroup getVariable ["assignedVehicle",objNull]);
//diag_log format ["Debug: %1 assigned vehicle is %2.",_unitGroup,_vehicle];
if (alive _vehicle) then {
	//diag_log format ["Debug: %1 assigned vehicle %2 is alive.",_victim,_unitGroup,_vehicle];
	if (_victim getVariable ["isDriver",false]) then {
		//diag_log format ["Debug: %1 is driver of %2 assigned vehicle %3",_unitGroup,_vehicle];
		if !((_unitGroup getVariable ["unitType",""]) isEqualTo "air_reinforce") then {_unitGroup setVariable ["unitType","aircrashed"];};
		_parachuted = [_vehicle,_unitGroup] call A3XAI_heliEvacuated;
		if (_parachuted) then {
			_nul = _vehicle spawn {
				_this setFuel 0;
				_this setVehicleAmmo 0;
				uiSleep 2.5;
				_this setDamage 1;
			};
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: AI %1 pilot unit %2 was killed, ejecting surviving crew.",(typeOf _vehicle),(typeOf _victim)];};
		};
	};
};

true
