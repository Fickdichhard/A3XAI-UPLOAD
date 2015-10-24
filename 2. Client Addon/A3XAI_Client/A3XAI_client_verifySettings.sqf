_startTime = diag_tickTime;

//Check value types
{
	_value = missionNamespace getVariable (_x select 0);
	if ((isNil "_value") or {(typeName _value) != (typeName (_x select 1))}) then {
		missionNamespace setVariable [(_x select 0),(_x select 1)];
		diag_log format ["[A3XAI] Error found in variable %1, resetting to default value.",(_x select 0)];
	};
} forEach [
	["A3XAI_client_radio",true],
	["A3XAI_client_radioSounds",true],
	//["A3XAI_client_deathMessages",true],
	//["A3XAI_client_deathMessageSound",true],
	["A3XAI_client_radioMessage0","[RADIO] Your radio is picking up a signal nearby."],
	["A3XAI_client_radioMessage1","[RADIO] %1: %2 is in this area. Stay on alert!"],
	["A3XAI_client_radioMessage2","[RADIO] %1: Target looks like a %2. Find them!"],
	["A3XAI_client_radioMessage3","[RADIO] %1: Target's range is about %2 meters. Move in on that position!"],
	["A3XAI_client_radioMessage4","[RADIO] %1: Lost contact with target. Breaking off pursuit."],
	["A3XAI_client_radioMessage5","[RADIO] %1: Target has been eliminated."],
	["A3XAI_client_radioMessage11","[RADIO] %1: %2 is somewhere in this location. Search the area!"],
	["A3XAI_client_radioMessage12","[RADIO] %1: Target is a %2. Stay on alert!"],
	["A3XAI_client_radioMessage13","[RADIO] %1: Target's distance is %2 meters. Move in to intercept!"],
	["A3XAI_client_radioMessage14","[RADIO] %1: We've lost contact with the target. Let's move out."],
	["A3XAI_client_radioMessage15","[RADIO] %1: The target has been killed."],
	["A3XAI_client_radioMessage20","Warning: Hostile %1 inbound."],
	["A3XAI_client_radioMessage31","[RADIO] %1: Target spotted below. Engaging."],
	["A3XAI_client_radioMessage32","[RADIO] %1: We've arrived at the location. Moving in on the target."],
	["A3XAI_client_radioMessage33","[RADIO] %1: Thats's the one we're looking for. Take him out."],
	["A3XAI_client_radioMessage34","[RADIO] %1: Located the target. Let's take him out."],
	["A3XAI_client_radioMessage35","[RADIO] %1: Priority target confirmed. Proceeding to engage."],
	["A3XAI_client_radioMessage41","[RADIO] %1 %2: Targets detected. Relaying position data."],
	["A3XAI_client_radioMessage42","[RADIO] %1 %2: Targets found at destination coordinates."],
	["A3XAI_client_radioMessage43","[RADIO] %1 %2: Movement detected. Targets selected."],
	["A3XAI_client_radioMessage44","[RADIO] %1 %2: Heat signatures confirmed. Designating targets."],
	["A3XAI_client_radioMessage45","[RADIO] %1 %2: Priority target located. Redirecting armed forces to target location."],
	["A3XAI_client_radioMessage51","[RADIO] %1 %2: Targets detected. Relaying position data."],
	["A3XAI_client_radioMessage52","[RADIO] %1 %2: Targets found at destination coordinates."],
	["A3XAI_client_radioMessage53","[RADIO] %1 %2: Movement detected. Targets selected."],
	["A3XAI_client_radioMessage54","[RADIO] %1 %2: Heat signatures confirmed. Designating targets."],
	["A3XAI_client_radioMessage55","[RADIO] %1 %2: Priority target located. Redirecting armed forces to target location."]
];

diag_log format ["[A3XAI] Verified all A3XAI settings in %1 seconds.",(diag_tickTime - _startTime)];
