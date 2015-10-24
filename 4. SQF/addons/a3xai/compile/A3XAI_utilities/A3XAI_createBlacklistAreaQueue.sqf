#include "\A3XAI\globaldefines.hpp"

if !((typeName _this) isEqualTo "ARRAY") exitWith {diag_log format ["Error: Wrong arguments sent to %1.",__FILE__]};
if (A3XAI_customBlacklistQueue isEqualTo []) then {
	A3XAI_customBlacklistQueue pushBack _this;
	_blacklistQueue = [] spawn {
		while {!(A3XAI_customBlacklistQueue isEqualTo [])} do {
			_statement = (A3XAI_customBlacklistQueue select 0);
			_blacklistName = _statement select 0;
			_statement deleteAt 0;
			if ((_statement select 1) > 1499) then {_statement set [1,1499];};
			_statement call A3XAI_createBlackListArea;
			A3XAI_customBlacklistQueue deleteAt 0;
			if (A3XAI_debugLevel > 0) then {diag_log format ["A3XAI Debug: Creating blacklist area at %1 (pos: %2) with radius %3.",_blacklistName,_statement select 0,_statement select 1];};
			uiSleep 1;
		};
	};
} else {
	A3XAI_customBlacklistQueue pushBack _this;
};
