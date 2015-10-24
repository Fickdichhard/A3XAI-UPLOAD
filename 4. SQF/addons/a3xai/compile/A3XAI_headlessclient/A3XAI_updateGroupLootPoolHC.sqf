private ["_unitGroup","_lootPool"];
_unitGroup = _this select 0;
_lootPool = _this select 1;

_unitGroup setVariable ["LootPool",_lootPool];

if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Updated group %1 loot pool to %2.",_unitGroup,_lootPool];};

true