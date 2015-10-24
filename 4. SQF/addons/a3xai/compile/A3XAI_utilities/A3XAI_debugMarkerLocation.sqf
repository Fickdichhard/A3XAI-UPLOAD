#include "\A3XAI\globaldefines.hpp"

private ["_mapMarkerArray","_objectString"];
_mapMarkerArray = missionNamespace getVariable ["A3XAI_mapMarkerArray",[]];
_objectString = str (_this);
if !(_objectString in _mapMarkerArray) then {	//Determine if marker is new
	if !(_objectString in allMapMarkers) then {
		private ["_marker"];
		_marker = createMarker [_objectString, _this];
		_marker setMarkerType "Waypoint";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerBrush "Solid";
	};
	_mapMarkerArray pushBack _objectString;
	missionNamespace setVariable ["A3XAI_mapMarkerArray",_mapMarkerArray];
};
