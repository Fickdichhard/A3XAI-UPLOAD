#include "\A3XAI\globaldefines.hpp"

private ["_killer", "_victim", "_killerRespectPoints", "_fragAttributes", "_killerPlayerUID", "_lastKillAt", "_vehicleKiller", "_killStack", "_distance", "_distanceBonus", "_overallRespectChange", "_newKillerScore", "_killMessage", "_newKillerFrags","_collision"];

_killer 	= _this select 0;
_victim 	= _this select 1;
_collision 	= _this select 2;

_fragAttributes = [];
_killerPlayerUID = getPlayerUID _killer;
_vehicleKiller = (vehicle _killer);

{
	if ((getPlayerUID _x) isEqualTo _killerPlayerUID) exitWith {
		_killer = _x;
	};
} forEach (crew _vehicleKiller);

if (A3XAI_enableRespectRewards) then {
	_killerRespectPoints = [];
	
	if (_vehicleKiller isEqualTo _killer) then {
		if (currentWeapon _killer isEqualTo "Exile_Melee_Axe") then {
			if (A3XAI_respectHumiliation > 0) then {
				_fragAttributes pushBack "Humiliation";
				_killerRespectPoints pushBack ["HUMILIATION", A3XAI_respectHumiliation];
			};
		} else {
			if (A3XAI_respectFragged > 0) then {
				//_fragAttributes pushBack "ENEMY FRAGGED";
				_fragAttributes pushBack "ENEMY AI FRAGGED";
				//_killerRespectPoints pushBack ["ENEMY FRAGGED", A3XAI_respectFragged];
				_killerRespectPoints pushBack ["ENEMY AI FRAGGED", A3XAI_respectFragged];
			};
		};
	} else {
		if (_collision) then {
			call {
				if (_vehicleKiller isKindOf "ParachuteBase") exitWith {
					if (A3XAI_respectChute > 0) then {
						_fragAttributes pushBack "Chute > Chopper";
						_killerRespectPoints pushBack ["CHUTE > CHOPPER", A3XAI_respectChute];
					};
				};
				if (_vehicleKiller isKindOf "Air") exitWith {
					if (A3XAI_respectBigBird > 0) then {
						_fragAttributes pushBack "Big Bird";
						_killerRespectPoints pushBack ["BIG BIRD", A3XAI_respectBigBird];
					};
				};
				if (A3XAI_respectRoadkill > 0) then {
					_fragAttributes pushBack "Road Kill";
					_killerRespectPoints pushBack ["Road Kill", A3XAI_respectRoadkill];
				};
			};
		} else {
			if (A3XAI_respectLetItRain > 0) then {
				_fragAttributes pushBack "Let it Rain";
				_killerRespectPoints pushBack ["LET IT RAIN", A3XAI_respectLetItRain];
			};
		};
	};
	
	_lastKillAt = _killer getVariable ["A3XAI_LastKillAt", 0];
	_killStack = _killer getVariable ["A3XAI_KillStack", 0];
	if ((diag_tickTime - _lastKillAt) < (getNumber (configFile >> "CfgSettings" >> "Respect" >> "Bonus" >> "killStreakTimeout"))) then {
		if (A3XAI_respectKillstreak > 0) then {
			_killStack = _killStack + 1;
			_fragAttributes pushBack (format ["%1x Kill Streak", _killStack]);
			_killerRespectPoints pushBack [(format ["%1x KILL STREAK", _killStack]), _killStack * A3XAI_respectKillstreak];
		};
		
	} else {
		_killStack = 1;
	};
	_killer setVariable ["A3XAI_KillStack", _killStack];
	_killer setVariable ["A3XAI_LastKillAt", diag_tickTime];
	
	_distance = floor (_victim distance _killer);
	_fragAttributes pushBack (format ["%1m Distance", _distance]);
	_distanceBonus = ((floor (_distance / 100)) * A3XAI_respectPer100m);
	if (_distanceBonus > 0) then {
		_killerRespectPoints pushBack [(format ["%1m RANGE BONUS", _distance]), _distanceBonus];
	};

	_overallRespectChange = 0;
	{
		_overallRespectChange = _overallRespectChange + (_x select 1);
	} forEach _killerRespectPoints;

	if (_overallRespectChange > 0) then {
		_newKillerScore = _killer getVariable ["ExileScore", 0];
		_newKillerScore = _newKillerScore + _overallRespectChange;
		_killer setVariable ["ExileScore", _newKillerScore];
		format["setAccountScore:%1:%2", _newKillerScore,_killerPlayerUID] call ExileServer_system_database_query_fireAndForget;
		[_killer, "showFragRequest", [_killerRespectPoints]] call A3XAI_sendExileMessage;
	};
	
	//["systemChatRequest", [_killMessage]] call ExileServer_system_network_send_broadcast; //To-do: Non-global version
	_newKillerFrags = _killer getVariable ["ExileKills", 0];
	_killer setVariable ["ExileKills", _newKillerFrags + 1];
	format["addAccountKill:%1", _killerPlayerUID] call ExileServer_system_database_query_fireAndForget;

	_killer call ExileServer_object_player_sendStatsUpdate;
};


if (A3XAI_enableDeathMessages) then {
	_killMessage = format ["%1 was killed by %2", _victim getVariable ["bodyName","Bandit"], (name _killer)];

	if !(_fragAttributes isEqualTo []) then {
		_killMessage = _killMessage + " (";
		{
			if (_forEachIndex > 0) then {
				_killMessage = _killMessage + ", ";
			};
			_killMessage = _killMessage + _x;
		} forEach _fragAttributes;
		_killMessage = _killMessage + ")";
	};
	
	{
		if (isPlayer _x) then {
			[_x, "systemChatRequest", [_killMessage]] call A3XAI_sendExileMessage;
		};
	} count (units (group _killer));
};

true
