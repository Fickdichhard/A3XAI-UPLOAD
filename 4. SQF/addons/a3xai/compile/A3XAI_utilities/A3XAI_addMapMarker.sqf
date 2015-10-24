#include "\A3XAI\globaldefines.hpp"

private ["_mapMarkerArray","_objectString"];
_mapMarkerArray = missionNamespace getVariable ["A3XAI_mapMarkerArray",[]];
_objectString = str (_this);
if !(_objectString in _mapMarkerArray) then {	//Determine if marker is new
	if !(_objectString in allMapMarkers) then {
		private ["_marker"];
		_marker = createMarker [_objectString, (getPosASL _this)];
		_marker setMarkerType "mil_circle";
		_marker setMarkerBrush "Solid";
	};
	_mapMarkerArray pushBack _objectString;
	missionNamespace setVariable ["A3XAI_mapMarkerArray",_mapMarkerArray];
};
if (_this isKindOf TRIGGER_OBJECT) then {	//Set marker as active
	_objectString setMarkerText "STATIC TRIGGER (ACTIVE)";
	_objectString setMarkerColor "ColorRed";
};