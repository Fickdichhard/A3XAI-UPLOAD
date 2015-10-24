#include "\A3XAI\globaldefines.hpp"

A3XAI_SMS = (_this select 1);

if (isDedicated) then {
	(owner (_this select 0)) publicVariableClient "A3XAI_SMS";
} else {
	A3XAI_SMS_PVS = [(_this select 0),A3XAI_SMS];
	publicVariableServer "A3XAI_SMS_PVS";
};

true