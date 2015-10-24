#include "\A3XAI\globaldefines.hpp"

private ["_victim","_killer","_unitGroup","_trigger","_dummy","_groupIsEmpty"];

_victim = _this select 0;
_killer = _this select 1;
_unitGroup = _this select 2;
_groupIsEmpty = _this select 3;

_trigger = _unitGroup getVariable ["trigger",A3XAI_defaultTrigger];

if (_groupIsEmpty) then {
	if (_trigger getVariable ["respawn",true]) then {
		_respawnCount = _trigger getVariable ["respawnLimit",-1];
		if !(_respawnCount isEqualTo 0) then {
			[0,_trigger,_unitGroup] call A3XAI_addRespawnQueue; //If there are still respawns possible... respawn the group
		} else {
			if (isDedicated) then {
				_trigger setVariable ["permadelete",true];	//deny respawn and delete trigger on next despawn.
			} else {
				A3XAI_setPermaDeleteSpawn_PVS = _unitGroup;
				publicVariableServer "A3XAI_setPermaDeleteSpawn_PVS";
			};
		};
	} else {
		if (isDedicated) then {
			_nul = _trigger spawn A3XAI_deleteCustomSpawn;
		} else {
			A3XAI_deleteCustomSpawn_PVS = _unitGroup;
			publicVariableServer "A3XAI_deleteCustomSpawn_PVS";
		};
	};
} else {
	if ((A3XAI_enableFindKiller) && {(combatMode _unitGroup) isEqualTo "YELLOW"}) then {
		0 = [_killer,_unitGroup] spawn A3XAI_huntKiller;
	};
	if (!(_trigger getVariable ["respawn",true])) then {
		_maxUnits = _trigger getVariable ["maxUnits",[0,0]]; //Reduce maximum AI for spawn trigger for each AI killed for non-respawning spawns.
		_maxUnits set [0,(_maxUnits select 0) - 1];
		if (A3XAI_debugLevel > 1) then {diag_log format["A3XAI Debug: MaxUnits variable for group %1 set to %2.",_unitGroup,_maxUnits];};
	};
};

true
