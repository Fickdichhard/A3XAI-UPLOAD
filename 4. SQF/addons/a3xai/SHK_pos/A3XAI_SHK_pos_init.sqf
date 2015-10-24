/*
  SHK_pos
  
  Version 0.24
  Author: Shuko (shuko@quakenet, miika@miikajarvinen.fi)
  Contributors: Cool=Azroul13, Hatifnat

  Forum: http://forums.bistudio.com/showthread.php?162695-SHK_pos

  Marker Based Selection
    Required Parameters:
      0 String   Area marker's name.
      
    Optional Parameters:
      1 Number            Water position. Default is only land positions allowed.
                            0   Find closest land. Search outwards 360 degrees (20 degree steps) and 20m steps.
                            1   Allow water positions.
                            2   Find only water positions.
      2 Array or String   One or multiple blacklist area markers which are excluded from the main marker area.
      3 Array, Number, Object or Vehicle Type         Force finding large enough empty position.
                            0   Max range from the selection position to look for empty space. Default is 200.
                            1   Vehicle or vehicle type to fit into an empty space.
                            
                            Examples:
                              [...,[300,heli]]       Array with distance and vehicle object.
                              [...,350]              Only distance given
                              [...,(typeof heli)]    Only vehicle type given
                              [...,heli]             Only vehicle object given

  Position Based Selection
    Required Parameters:
      0 Object or Position  Anchor point from where the relative position is calculated from.
      1 Array or Number     Distance from anchor.
      
    Optional Parameters:
      2 Array of Number     Direction from anchor. Default is random between 0 and 360.
      3 Number              Water position. Default is only land positions allowed.
                              0   Find closest land. Search outwards 360 degrees (20 degree steps) and 20m steps.
                              1   Allow water positions.
                              2   Find only water positions.
      4 Array               Road positions.
                              0  Number  Road position forcing. Default is 0.
                                   0    Do not search for road positions.
                                   1    Find closest road position. Return the generated random position if none found.
                                   2    Find closest road position. Return empty array if none found.
                              1  Number   Road search range. Default is 200m.
      5 Array, Number, Object or Vehicle Type         Force finding large enough empty position.
                              0   Max range from the selection position to look for empty space. Default is 200.
                              1   Vehicle or vehicle type to fit into an empty space.
                            
                            Examples:
                              [...,[300,heli]]       Array with distance and vehicle object.
                              [...,350]              Only distance given
                              [...,(typeof heli)]    Only vehicle type given
                              [...,heli]             Only vehicle object given                              
    
  Usage:
    Preprocess the file in init.sqf:
      call compile preprocessfile "SHK_pos\A3XAI_SHK_pos_init.sqf";
    
    Actually getting the position:
      pos = [parameters] call A3XAI_SHK_pos;
*/
// Functions
A3XAI_SHK_pos_getPos = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_getpos.sqf",A3XAI_directory];
A3XAI_SHK_pos_getPosMarker = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_getposmarker.sqf",A3XAI_directory];

// Sub functions
A3XAI_SHK_pos_fnc_findClosestPosition = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_findclosestposition.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_getMarkerCorners = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_getmarkercorners.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_getMarkerShape = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_getmarkershape.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_getPos = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_getpos.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_getPosFromCircle = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_getposfromcircle.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_getPosFromEllipse = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_getposfromellipse.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_getPosFromRectangle = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_getposfromrectangle.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_getPosFromSquare = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_getposfromsquare.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_isBlacklisted = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_isblacklisted.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_isInCircle = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_isincircle.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_isInEllipse = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_isinellipse.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_isInRectangle = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_isinrectangle.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_isSamePosition = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_issameposition.sqf",A3XAI_directory];
A3XAI_SHK_pos_fnc_rotatePosition = compileFinal preprocessFileLineNumbers format ["%1\shk_pos\A3XAI_SHK_pos_fnc_rotateposition.sqf",A3XAI_directory];

// Wrapper function
// Decide which function to call based on parameters.
A3XAI_SHK_pos = {
  private ["_pos"];
  _pos = [];

  // Only marker is given as parameter
  if (typename _this isEqualTo "STRING") then {
    _pos = [_this] call A3XAI_SHK_pos_getPosMarker;

  // Parameter array
  } else {
    if (typename (_this select 0) isEqualTo "STRING") then {
      _pos = _this call A3XAI_SHK_pos_getPosMarker;
    } else {
      _pos = _this call A3XAI_SHK_pos_getPos;
    };
  };

  // Return position
  _pos
};