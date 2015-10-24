#include "\A3XAI\globaldefines.hpp"

private ["_HCObject","_versionHC","_compatibleVersions","_positionHC","_useRemoteConfigs"];
_HCObject = _this select 0;
_versionHC = _this select 1;
_useRemoteConfigs = _this select 2;

A3XAI_HC_serverResponse = false;
if (((owner A3XAI_HCObject) isEqualTo 0) && {(typeOf _HCObject) isEqualTo "HeadlessClient_F"}) then {
	_compatibleVersions = [configFile >> "CfgPatches" >> "A3XAI","compatibleHCVersions",[]] call BIS_fnc_returnConfigEntry;
	if (_versionHC in _compatibleVersions) then {
		A3XAI_HCObject = _HCObject;
		A3XAI_HCObject allowDamage false;
		A3XAI_HCObject enableSimulationGlobal false;
		A3XAI_HCObject addEventHandler ["Local",{
			if (_this select 1) then {
				private["_unit","_unitGroup"];
				A3XAI_HCIsConnected = false;
				A3XAI_HCObjectOwnerID = 0;
				A3XAI_HCObject = objNull;
				_unit = _this select 0;
				_unitGroup = (group _unit);
				_unit removeAllEventHandlers "Local";
				if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Deleting disconnected headless client unit %1.",typeOf _unit];};
				deleteVehicle _unit;
				deleteGroup _unitGroup;
			};
		}];
		A3XAI_HCObjectOwnerID = (owner A3XAI_HCObject);
		A3XAI_HCIsConnected = true;
		A3XAI_HC_serverResponse = if (_useRemoteConfigs) then {
			A3XAI_pushedHCVariables
		} else {
			true
		};
		_positionHC = getPosATL A3XAI_HCObject;
		if (({if (_positionHC in _x) exitWith {1}} count (nearestLocations [_positionHC,[BLACKLIST_OBJECT_GENERAL],BLACKLIST_AREA_HC_SIZE])) isEqualTo 0) then {
			[_positionHC,TEMP_BLACKLIST_AREA_HC_SIZE] call A3XAI_createBlackListArea;
			diag_log format ["[A3XAI] Created 750m radius blacklist area at HC position %1",_positionHC];
		};
		diag_log format ["[A3XAI] Headless client %1 (owner: %2) logged in successfully.",A3XAI_HCObject,A3XAI_HCObjectOwnerID];
	} else {
		diag_log format ["[A3XAI] Headless client %1 (owner: %2) has wrong A3XAI version %3 (Compatible versions: %4).",_HCObject,owner _HCObject,_versionHC,_compatibleVersions];
	};
} else {
	diag_log format ["[A3XAI] Rejecting connection from HC %1. A headless client is already connected: %2. Client object type: %3.",(_this select 1),!((owner A3XAI_HCObject) isEqualTo 0),typeOf _HCObject];
};

(owner _HCObject) publicVariableClient "A3XAI_HC_serverResponse";
