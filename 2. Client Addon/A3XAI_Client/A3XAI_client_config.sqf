/*
	A3XAI Client-side Addon Configuration File
	
*/


/*	A3XAI Client Addon Settings
--------------------------------------------------------------------------------------------------------------------*/	

//Enables use of client-side radio functions. A3XAI_radioMsgs must be set 'true' in A3XAI_config.sqf.
A3XAI_client_radio = true;

//Enables sound notifications when displaying radio messages
A3XAI_client_radioSounds = true;


/*	A3XAI Text String Settings
--------------------------------------------------------------------------------------------------------------------*/	

//AI radio static message
A3XAI_client_radioMessage0 = "[RADIO] Your radio is picking up a signal nearby.";	//Message displayed when radio sound transmitted without AI dialogue.

//AI radio messages (AI-killer dialogue)
A3XAI_client_radioMessage1 = "[RADIO] %1: %2 is in this area. Stay on alert!"; //%1: AI leader name, %2: Target player name
A3XAI_client_radioMessage2 = "[RADIO] %1: Target looks like a %2. Find them!"; //%1: AI leader name, %2: Target player type
A3XAI_client_radioMessage3 = "[RADIO] %1: Target's range is about %2 meters. Move in on that position!"; //%1: AI leader name, %2: Target player distance
A3XAI_client_radioMessage4 = "[RADIO] %1: Lost contact with target. Breaking off pursuit."; //%1: AI leader name
A3XAI_client_radioMessage5 = "[RADIO] %1: Target has been eliminated."; //%1: AI leader name

//AI radio messages (Dynamic AI hunter dialogue)
A3XAI_client_radioMessage11 = "[RADIO] %1: %2 is somewhere in this location. Search the area!"; //%1: AI leader name, %2: Target player name
A3XAI_client_radioMessage12 = "[RADIO] %1: Target is a %2. Stay on alert!"; //%1: AI leader name, %2: Target player type
A3XAI_client_radioMessage13 = "[RADIO] %1: Target's distance is %2 meters. Move in to intercept!"; //%1: AI leader name, %2: Target player distance
A3XAI_client_radioMessage14 = "[RADIO] %1: We've lost contact with the target. Let's move out."; //%1: AI leader name
A3XAI_client_radioMessage15 = "[RADIO] %1: The target has been killed."; //%1: AI leader name

//AI air patrol reinforcement warning message
A3XAI_client_radioMessage20 = "Warning: Hostile %1 inbound."; //%1: Air vehicle type

//AI air patrol dialogue. Displayed when player is detected by air patrol.
A3XAI_client_radioMessage31 = "[RADIO] %1: Target spotted below. Engaging."; //%1: AI leader name
A3XAI_client_radioMessage32 = "[RADIO] %1: We've arrived at the location. Moving in on the target."; //%1: AI leader name
A3XAI_client_radioMessage33 = "[RADIO] %1: Thats's the one we're looking for. Take him out."; //%1: AI leader name
A3XAI_client_radioMessage34 = "[RADIO] %1: Located the target. Let's take him out."; //%1: AI leader name
A3XAI_client_radioMessage35 = "[RADIO] %1: Priority target confirmed. Proceeding to engage."; //%1: AI leader name

//UAV patrol dialogue. Displayed when player is detected.
A3XAI_client_radioMessage41 = "[RADIO] %1 %2: Targets detected. Relaying position data."; //%1: UAV Group, %2: UAV Type
A3XAI_client_radioMessage42 = "[RADIO] %1 %2: Targets found at destination coordinates."; //%1: UAV Group, %2: UAV Type
A3XAI_client_radioMessage43 = "[RADIO] %1 %2: Movement detected. Targets selected."; //%1: UAV Group, %2: UAV Type
A3XAI_client_radioMessage44 = "[RADIO] %1 %2: Heat signatures confirmed. Designating targets."; //%1: UAV Group, %2: UAV Type
A3XAI_client_radioMessage45 = "[RADIO] %1 %2: Priority target located. Redirecting armed forces to target location."; //%1: UAV Group, %2: UAV Type

//UGV patrol dialogue. Displayed when player is detected.
A3XAI_client_radioMessage51 = "[RADIO] %1 %2: Targets detected. Relaying position data."; //%1: UGV Group, %2: UGV Type
A3XAI_client_radioMessage52 = "[RADIO] %1 %2: Targets found at destination coordinates."; //%1: UGV Group, %2: UGV Type
A3XAI_client_radioMessage53 = "[RADIO] %1 %2: Movement detected. Targets selected."; //%1: UGV Group, %2: UGV Type
A3XAI_client_radioMessage54 = "[RADIO] %1 %2: Heat signatures confirmed. Designating targets."; ///%1: UGV Group, %2: UGV Type
A3XAI_client_radioMessage55 = "[RADIO] %1 %2: Priority target located. Redirecting armed forces to target location."; //%1: UGV Group, %2: UGV Type
