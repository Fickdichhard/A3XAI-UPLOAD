#include "\A3XAI\globaldefines.hpp"

private ["_trigger","_arrayString","_triggerArray"];
_trigger = _this select 0;
_arrayString = _this select 1;

_triggerArray = missionNamespace getVariable [_arrayString,[]];
if (!isNull _trigger) then {
	if (_trigger in _triggerArray) then {
		_triggerArray = _triggerArray - [_trigger,objNull];
	} else {
		if ((triggerStatements _trigger select 1) isEqualTo "") then {
			_triggerArray pushBack _trigger;
		};
	};
};

_triggerArray = _triggerArray - [objNull];
missionNamespace setVariable [_arrayString,_triggerArray];