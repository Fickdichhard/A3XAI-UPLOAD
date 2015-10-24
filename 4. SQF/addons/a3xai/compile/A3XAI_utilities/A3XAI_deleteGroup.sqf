#include "\A3XAI\globaldefines.hpp"

[_this,false] call A3XAI_updGroupCount;

{
	if (alive _x) then {
		deleteVehicle _x;
	} else {
		[_x] joinSilent grpNull;
	};
} count (units _this);
deleteGroup _this;

true