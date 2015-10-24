#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup", "_unitLevel", "_anchor", "_unitType", "_groupSize", "_functionCall", "_check", "_lootPool","_miscData1","_miscData2","_anchorType"];
	
_unitGroup = _this select 0;
_unitLevel = _this select 1;
_anchor = _this select 2;
_unitType = _this select 3;
_groupSize = _this select 4;
_lootPool = _this select 5;
_miscData1 = if ((count _this) > 6) then {_this select 6};
_miscData2 = if ((count _this) > 7) then {_this select 7};

call {
	_anchorType = (typeName _anchor);
	if (_anchorType isEqualTo "ARRAY") exitWith {
		_anchor = createTrigger [TRIGGER_OBJECT,_anchor,false];
		_unitGroup setVariable ["trigger",_anchor];
		if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Created group trigger for %1 group %2.",_unitType,_unitGroup];};
	};
	if (_anchorType isEqualTo "OBJECT") exitWith {
		_unitGroup setVariable ["assignedVehicle",_anchor];
		if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: %1 group %2 has assigned vehicle %3 (%4).",_unitType,_unitGroup,_anchor,(typeOf _anchor)];};
	};
	_anchor = objNull;
};

_unitGroup setVariable ["unitLevel",_unitLevel];
_unitGroup setVariable ["unitType",_unitType];
_unitGroup setVariable ["GroupSize",_groupSize];

_unitGroup call A3XAI_initNoAggroStatus;

if !(_lootPool isEqualTo []) then {_unitGroup setVariable ["LootPool",_lootPool];};

if !(isNil "_miscData1") then {
	call {
		if (_unitType isEqualTo "dynamic") exitWith {
			_unitGroup setVariable ["targetplayer",_miscData1];
			_anchor setVariable ["targetplayer",_miscData1];
			if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: %1 group %2 has target player %3.",_unitType,_unitGroup,_miscData1];};
		};
	};
};

if (!isNil "_miscData2") then {
	
};

_functionCall = missionNamespace getVariable ["A3XAI_handle"+_unitType,{false}];
_check = _unitGroup call _functionCall;

if (A3XAI_debugLevel > 0) then {
	if (_check) then {
		diag_log format ["A3XAI Debug: HC received new group from server: %1. Processing new group with function %2.",_unitGroup,("A3XAI_handle"+_unitType)];
	} else {
		diag_log format ["A3XAI Debug: Function %1 not found.","A3XAI_handle"+_unitType]
	};
};

0 = [_unitGroup,_unitLevel] spawn A3XAI_addGroupManager;

A3XAI_HCGroupsCount = A3XAI_HCGroupsCount + 1;

true