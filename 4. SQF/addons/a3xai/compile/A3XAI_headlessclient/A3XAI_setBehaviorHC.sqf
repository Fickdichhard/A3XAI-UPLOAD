private ["_unitGroup","_mode"];
_unitGroup = _this select 0;
_mode = _this select 1;

call {
	if (_mode isEqualTo 0) exitWith {
		_unitGroup setBehaviour "CARELESS";
		{_x doWatch objNull} forEach (units _unitGroup);
		_unitGroup setVariable ["EnemiesIgnored",true];
		true
	};
	if (_mode isEqualTo 1) exitWith {
		_unitGroup setBehaviour "AWARE";
		_unitGroup setVariable ["EnemiesIgnored",false];
		true
	};
	false
};
