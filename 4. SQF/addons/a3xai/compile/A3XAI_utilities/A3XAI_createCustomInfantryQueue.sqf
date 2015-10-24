#include "\A3XAI\globaldefines.hpp"

if !((typeName _this) isEqualTo "ARRAY") exitWith {diag_log format ["Error: Wrong arguments sent to %1 (%2).",__FILE__,_this]};
if (A3XAI_createCustomSpawnQueue isEqualTo []) then {
	A3XAI_createCustomSpawnQueue pushBack _this;
	_infantryQueue = [] spawn {
		while {!(A3XAI_createCustomSpawnQueue isEqualTo [])} do {
			(A3XAI_createCustomSpawnQueue select 0) call A3XAI_createCustomSpawn;
			A3XAI_createCustomSpawnQueue deleteAt 0;
			uiSleep 1;
		};
	};
} else {
	A3XAI_createCustomSpawnQueue pushBack _this;
};
