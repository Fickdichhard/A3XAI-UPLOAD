#include "\A3XAI\globaldefines.hpp"

_unit = (_this select 0);
_item = (_this select 1);

_slot = floor (random 3);
if ((_slot isEqualTo 0) && {_unit canAddItemToUniform _item}) exitWith {_unit addItemToUniform _item; true};
if ((_slot isEqualTo 1) && {_unit canAddItemToVest _item}) exitWith {_unit addItemToVest _item; true};
if ((_slot isEqualTo 2) && {_unit canAddItemToBackpack _item}) exitWith {_unit addItemToBackpack _item; true};

false