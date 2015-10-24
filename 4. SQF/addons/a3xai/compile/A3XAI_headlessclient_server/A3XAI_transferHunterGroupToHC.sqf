#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_targetPlayer"];

_unitGroup = _this select 0;
_targetPlayer = _this select 1;

A3XAI_sendHunterGroupHC = [_unitGroup,_targetPlayer];
A3XAI_HCObjectOwnerID publicVariableClient "A3XAI_sendHunterGroupHC";

true
