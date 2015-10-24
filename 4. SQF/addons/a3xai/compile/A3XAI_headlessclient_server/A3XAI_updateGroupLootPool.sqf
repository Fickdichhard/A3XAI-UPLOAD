#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_lootPool","_lootIndex"];
_unitGroup = _this select 0;
_lootIndex = _this select 1;

_lootPool = _unitGroup getVariable ["LootPool",[]];
_lootPool deleteAt _lootIndex;

true