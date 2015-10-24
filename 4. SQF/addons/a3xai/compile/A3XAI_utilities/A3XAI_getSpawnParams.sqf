#include "\A3XAI\globaldefines.hpp"

private ["_nearestLocations", "_nearestLocationType", "_spawnParams"];

_nearestLocations = nearestLocations [_this,["NameCityCapital","NameCity","NameVillage","NameLocal"],1000];
_nearestLocationType = if !(_nearestLocations isEqualTo []) then {
	type (_nearestLocations select 0);
} else {
	""; //Position not in range of any categorized location
};
_spawnParams = call {
	if (_nearestLocationType isEqualTo "NameCityCapital") exitWith {[A3XAI_minAI_capitalCity,A3XAI_addAI_capitalCity,A3XAI_unitLevel_capitalCity,A3XAI_spawnChance_capitalCity]};
	if (_nearestLocationType isEqualTo "NameCity") exitWith {[A3XAI_minAI_city,A3XAI_addAI_city,A3XAI_unitLevel_city,A3XAI_spawnChance_city]};
	if (_nearestLocationType isEqualTo "NameVillage") exitWith {[A3XAI_minAI_village,A3XAI_addAI_village,A3XAI_unitLevel_village,A3XAI_spawnChance_village]};
	if (_nearestLocationType isEqualTo "NameLocal") exitWith {[A3XAI_minAI_remoteArea,A3XAI_addAI_remoteArea,A3XAI_unitLevel_remoteArea,A3XAI_spawnChance_remoteArea]};
	[A3XAI_minAI_wilderness,A3XAI_addAI_wilderness,A3XAI_unitLevel_wilderness,A3XAI_spawnChance_wilderness] //Default
};

_spawnParams