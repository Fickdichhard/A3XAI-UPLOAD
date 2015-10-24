_startTime = diag_tickTime;

if (A3XAI_HC_serverResponse isEqualTo []) exitWith {};

{
	_variableName 	= _x select 0;
	_variableValue 	= _x select 1;
	
	missionNamespace setVariable [format ["A3XAI_%1",_variableName],_variableValue];
	diag_log format ["Debug: %1:%2",_variableName,_variableValue];
} forEach A3XAI_HC_serverResponse;

diag_log format ["[A3XAI] Loaded all A3XAI settings in %1 seconds.",(diag_tickTime - _startTime)];

true
