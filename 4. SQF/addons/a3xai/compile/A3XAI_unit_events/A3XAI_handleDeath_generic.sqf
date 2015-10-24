#include "\A3XAI\globaldefines.hpp"

private["_victim","_killer","_unitGroup","_unitType","_unitsAlive"];

_victim = _this select 0;
_killer = _this select 1;
_unitGroup = _this select 2;
_unitType = _this select 3;
_unitsAlive = _this select 4;

try {
	
	if (isPlayer _killer) then {
		if (A3XAI_cleanupDelay isEqualTo 0) then {
			throw format ["A3XAI Debug: Clearing gear for %1 (cleanupDelay = 0)",_victim];
		};
		if (_victim getVariable ["CollisionKilled",false]) then {
			throw format ["A3XAI Debug: %1 AI unit %2 was killed by collision damage caused by %3. Unit gear cleared.",_unitType,_victim,_killer];
		};
		_unitLevel = _unitGroup getVariable ["unitLevel",1];
		if (isDedicated) then {
			0 = [_victim,_unitLevel] spawn A3XAI_generateLootOnDeath;
		} else {
			A3XAI_generateLootOnDeath_PVS = [_victim,_unitLevel];
			publicVariableServer "A3XAI_generateLootOnDeath_PVS";
		};
	} else {
		if (_killer isEqualTo _victim) then {
			throw format ["A3XAI Debug: %1 AI unit %2 was killed by non-player. Unit gear cleared.",_unitType,_victim];
		};
	};
} catch {
	_victim call A3XAI_purgeUnitGear;
	if (A3XAI_debugLevel > 0) then {
		diag_log _exception;
	};
};

true
