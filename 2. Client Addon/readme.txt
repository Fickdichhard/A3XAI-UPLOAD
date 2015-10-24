A3XAI Client Optional Addon
----------------------------

1. How to install
------------------
The A3XAI client optional addon is used by A3XAI to run client-side commands. To install:
1. Unpack your mission pbo file (example: Exile.Altis.pbo) and copy the A3XAI_Client folder into the extracted folder.
2. Edit your extracted mission folder's init.sqf (if no init.sqf exists - create one) and insert this at the end:

	#include "A3XAI_Client\A3XAI_initclient.sqf";

3. Repack your mission pbo file.
4. Add the required BattlEye filters found in "Needed BE Exceptions for Client Addon.txt"
5. Start your server.
	

2. How to configure
------------------
Edit A3XAI_client_config.sqf to change settings and enable/disable features. By default, all features are enabled.

Brief summary of available settings:

A3XAI_radioMsgs: 					Enables text message warnings to players with radios when they are under pursuit by AI.
A3XAI_client_radioSounds:			Enables audio notifications.
A3XAI_client_radioMessage<number>:	Set radio text messages intercepted from AI communications.