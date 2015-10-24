#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_isNewGroup"];
_unitGroup = _this select 0;
_isNewGroup = _this select 1;

if (isNull _unitGroup) exitWith {false};

if (_isNewGroup) then {
	A3XAI_activeGroups pushBack _unitGroup;
} else {
	A3XAI_activeGroups = A3XAI_activeGroups - [_unitGroup,grpNull];
};

true