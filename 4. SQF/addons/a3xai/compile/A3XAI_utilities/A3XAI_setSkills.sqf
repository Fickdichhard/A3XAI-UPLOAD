#include "\A3XAI\globaldefines.hpp"

private["_unit","_unitLevel","_skillSeed","_skillArray","_skillTypeArray"];
_unit = _this select 0;
_unitLevel = _this select 1;
_skillArray = missionNamespace getVariable ["A3XAI_skill"+str(_unitLevel),[	["aimingAccuracy",0.05,0.10],["aimingShake",0.40,0.50],["aimingSpeed",0.40,0.50],["spotDistance",0.40,0.50],["spotTime",0.40,0.50],["courage",0.40,0.50],["reloadSpeed",0.40,0.50],["commanding",0.40,0.50],["general",0.40,0.50]]];
_skillSeed = (random 1);
_skillTypeArray = ["aimingAccuracy","aimingShake","aimingSpeed","spotDistance","spotTime","courage","reloadSpeed","commanding","general"];
{
	_unit setSkill [_skillTypeArray select _forEachIndex,((_x select 1) + random ((_x select 2)-(_x select 1))) min 1];
	//_unit setSkill [_skillTypeArray select _forEachIndex,linearConversion [0,1,_skillSeed,(_x select 1),((_x select 2) min 1),true]];
} forEach _skillArray;
