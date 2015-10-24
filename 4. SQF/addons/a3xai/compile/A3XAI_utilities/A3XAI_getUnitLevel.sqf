#include "\A3XAI\globaldefines.hpp"

private ["_indexWeighted","_unitLevelIndexTable"];
_unitLevelIndexTable = _this;

_indexWeighted = call {
	if (_unitLevelIndexTable isEqualTo "airvehicle") exitWith {A3XAI_levelIndicesAir};
	if (_unitLevelIndexTable isEqualTo "landvehicle") exitWith {A3XAI_levelIndicesLand};
	if (_unitLevelIndexTable isEqualTo "uav") exitWith {A3XAI_levelIndicesUAV};
	if (_unitLevelIndexTable isEqualTo "ugv") exitWith {A3XAI_levelIndicesUGV};
	[0]
};
	
A3XAI_unitLevels select (_indexWeighted call A3XAI_selectRandom)