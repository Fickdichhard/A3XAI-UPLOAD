
_message = _this;
if ((typeName _message) isEqualTo "STRING") then {
	systemChat _message;
	if (A3XAIC_deathMessageSound) then {
		playsound "AddItemOK";
	};
} else {
	diag_log format ["A3XAI Error: Kill message is non-string: %1",_message];
};

true