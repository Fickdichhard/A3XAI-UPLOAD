#include "\A3XAI\globaldefines.hpp"

private ["_unitLevel", "_weaponIndices", "_weaponList", "_weaponsList", "_weaponSelected", "_weaponListLeveled"];

_unitLevel = _this;

_weaponIndices = missionNamespace getVariable ["A3XAI_weaponTypeIndices"+str(_unitLevel),[0,1,2,3]];
_weaponList = ["A3XAI_pistolList","A3XAI_rifleList","A3XAI_machinegunList","A3XAI_sniperList"] select (_weaponIndices call A3XAI_selectRandom);
_weaponListLeveled = _weaponList+str(_unitLevel);
_weaponsList = missionNamespace getVariable _weaponListLeveled;
if (isNil "_weaponsList") then {_weaponsList = missionNamespace getVariable _weaponList;};
_weaponSelected = _weaponsList call A3XAI_selectRandom;

//diag_log format ["Debug: Generated weapon %1",_weaponSelected];

_weaponSelected