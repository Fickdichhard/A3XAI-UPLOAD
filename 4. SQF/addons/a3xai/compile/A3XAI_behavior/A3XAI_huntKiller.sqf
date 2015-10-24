#include "\A3XAI\globaldefines.hpp"

private ["_unitGroup","_targetPlayer","_startPos","_chaseDistance","_enableHCReady","_nearBlacklistedAreas","_targetPlayerPos"];

_targetPlayer = _this select 0;
_unitGroup = _this select 1;

//Disable killer-finding for dynamic AI in hunting mode
if (_unitGroup getVariable ["seekActive",false]) exitWith {};

//If group is already pursuing player and target player has killed another group member, then extend pursuit time.
if (((_unitGroup getVariable ["pursuitTime",0]) > 0) && {((_unitGroup getVariable ["targetKiller",""]) isEqualTo (name _targetPlayer))}) exitWith {
	_unitGroup setVariable ["pursuitTime",((_unitGroup getVariable ["pursuitTime",0]) + 20)];
	if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: Pursuit time +20 sec for Group %1 (Target: %2) to %3 seconds.",_unitGroup,name _targetPlayer,(_unitGroup getVariable ["pursuitTime",0]) - diag_tickTime]};
};

_enableHCReady = false;
if (_unitGroup getVariable ["HC_Ready",false]) then { //If HC mode enabled and AI group is controlled by server, prevent it from being transferred to HC until hunting mode is over.
	_unitGroup setVariable ["HC_Ready",false];
	_enableHCReady = true;
};

_startPos = _unitGroup getVariable ["trigger",(getPosASL (leader _unitGroup))];
_chaseDistance = _unitGroup getVariable ["patrolDist",250];
_targetPlayerPos = getPosATL _targetPlayer;
_nearBlacklistedAreas = nearestLocations [_targetPlayerPos,[BLACKLIST_OBJECT_GENERAL],1500];

_unitGroup setFormDir ([(leader _unitGroup),_targetPlayerPos] call BIS_fnc_dirTo);

if ((_startPos distance _targetPlayerPos) < _chaseDistance) then {
	private ["_leader","_ableToChase","_marker"];
	if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Group %1 has entered pursuit state for 180 seconds. Target: %2.",_unitGroup,_targetPlayer];};

	//Set pursuit timer
	_unitGroup setVariable ["pursuitTime",diag_tickTime+180];
	_unitGroup setVariable ["targetKiller",name _targetPlayer];
	
	
	if (A3XAI_enableDebugMarkers) then {
		_markername = format ["%1 Target",_unitGroup];
		if (_markername in allMapMarkers) then {deleteMarker _markername; uiSleep 0.5;};
		_marker = createMarker [_markername,getPosASL _targetPlayer];
		_marker setMarkerText _markername;
		_marker setMarkerType "mil_warning";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerBrush "Solid";
	};
	
	//Begin pursuit state.
	_ableToChase = true;
	while { 
		_ableToChase &&
		{isPlayer _targetPlayer} && 
		{alive _targetPlayer} &&
		{((_startPos distance _targetPlayer) < _chaseDistance)} &&
		{(vehicle _targetPlayer) isKindOf "Land"}
	} do {
		_targetPlayerPos = getPosATL _targetPlayer;
		if (({_targetPlayerPos in _x} count _nearBlacklistedAreas) isEqualTo 0) then {
			if ((_unitGroup knowsAbout _targetPlayer) < 4) then {_unitGroup reveal [_targetPlayer,4]};
			(units _unitGroup) doMove _targetPlayerPos;
		};
		
		if (A3XAI_debugLevel > 1) then {diag_log format ["A3XAI Debug: AI group %1 in pursuit state. Pursuit time remaining: %2 seconds.",_unitGroup,(_unitGroup getVariable ["pursuitTime",0]) - diag_tickTime];};
		
		if ((A3XAI_enableRadioMessages) && {0.7 call A3XAI_chance}) then {
			_leader = (leader _unitGroup);
			if ((alive _leader) && {(_targetPlayer distance _leader) <= RECEIVE_DIST_RADIO_HUNTKILLER}) then {
				_nearbyUnits = _targetPlayerPos nearEntities [[PLAYER_UNITS,"LandVehicle"],TRANSMIT_RANGE_RADIO_HUNTKILLER];
				if !(_nearbyUnits isEqualTo []) then {	//Have at least 1 player to send a message to
					if ((_unitGroup getVariable ["GroupSize",0]) > 1) then {	//Have at least 1 AI unit to send a message from
						_speechIndex = (floor (random 3));
						_radioSpeech = call {
							if (_speechIndex isEqualTo 0) exitWith {
								[1,[(name _leader),(name _targetPlayer)]]
							};
							if (_speechIndex isEqualTo 1) exitWith {
								[2,[(name _leader),(getText (configFile >> "CfgVehicles" >> (typeOf _targetPlayer) >> "displayName"))]]
							};
							if (_speechIndex isEqualTo 2) exitWith {
								[3,[(name _leader),round (_leader distance _targetPlayer)]]
							};
							[0,[]] 
						};
						{
							if ((isPlayer _x) && {({if (RADIO_ITEM in (assignedItems _x)) exitWith {1}} count (units (group _x))) > 0}) then {
								[_x,_radioSpeech] call A3XAI_radioSend;
							};
						} count _nearbyUnits;
					} else {
						{
							if ((isPlayer _x) && {({if (RADIO_ITEM in (assignedItems _x)) exitWith {1}} count (units (group _x))) > 0}) then {
								[_x,[0,[]]] call A3XAI_radioSend;
							};
						} count _nearbyUnits;
					};
				};
			};
		};
		if (A3XAI_enableDebugMarkers) then {
			_marker setMarkerPos (getPosASL _targetPlayer);
		};
		_ableToChase = ((!isNull _unitGroup) && {diag_tickTime < (_unitGroup getVariable ["pursuitTime",0])} && {(_unitGroup getVariable ["GroupSize",0]) > 0});
		if (_ableToChase) then {uiSleep 20};
	};

	if !(isNull _unitGroup) then {
		//End of pursuit state. Re-enable patrol state.
		_unitGroup setVariable ["pursuitTime",0];
		_unitGroup setVariable ["targetKiller",""];
		//_unitGroup lockWP false;
		
		if ((_unitGroup getVariable ["GroupSize",0]) > 0) then {
			_waypoints = (waypoints _unitGroup);
			_unitGroup setCurrentWaypoint (_waypoints call A3XAI_selectRandom);
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Pursuit state ended for group %1. Returning to patrol state.",_unitGroup];};
			
			if (A3XAI_enableRadioMessages) then {
				_leader = (leader _unitGroup);
				if ((alive _leader) && {(_targetPlayer distance _leader) <= RECEIVE_DIST_RADIO_HUNTKILLER} && {((_unitGroup getVariable ["GroupSize",0]) > 1)} && {isPlayer _targetPlayer}) then {
					_radioText = if (alive _targetPlayer) then {4} else {5};
					_radioSpeech = [_radioText,[name (leader _unitGroup)]];
					_nearbyUnits = (getPosASL _targetPlayer) nearEntities [["LandVehicle",PLAYER_UNITS],TRANSMIT_RANGE_RADIO_HUNTKILLER];
					{
						if ((isPlayer _x) && {({if (RADIO_ITEM in (assignedItems _x)) exitWith {1}} count (units (group _x))) > 0}) then {
							[_x,_radioSpeech] call A3XAI_radioSend;
						};
					} count _nearbyUnits;
				};
			};
		};
		
		if (_enableHCReady) then {
			_unitGroup setVariable ["HC_Ready",true];
		};
	};
	
	if (A3XAI_enableDebugMarkers) then {
		deleteMarker _marker;
	};
};
