#include "\A3XAI\globaldefines.hpp"

private ["_currentTime", "_monitorReport", "_getUptime", "_currentSec", "_outHour", "_outMin", "_outSec", "_uptime"];

_currentTime = diag_tickTime;
_monitorReport = _currentTime;

_getUptime = {
	private ["_currentSec","_outSec","_outMin","_outHour"];
	_currentSec = diag_tickTime;
	_outHour = floor (_currentSec/3600);
	_outMin = floor ((_currentSec - (_outHour*3600))/60);
	_outSec = floor (_currentSec - (_outHour*3600) - (_outMin*60));
	
	[_outHour,_outMin,_outSec]
};

while {true} do {
	_currentTime = diag_tickTime;

	if ((A3XAI_monitorReportRate > 0) && {((_currentTime - _monitorReport) > A3XAI_monitorReportRate)}) then {
		_uptime = [] call _getUptime;
		diag_log format ["A3XAI Monitor: Uptime: %1:%2:%3. FPS: %4. HC Groups: %5.",_uptime select 0, _uptime select 1, _uptime select 2,round(diag_fps),A3XAI_HCGroupsCount];
		_monitorReport = _currentTime;
	};
	uiSleep 30;
};
