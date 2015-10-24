/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
if (!hasInterface && {!isDedicated}) exitWith {diag_log format ["A3XAI blocked execution of %1.",__FILE__];};

if (isDedicated) then {
	call compile preprocessFileLineNumbers "exile_server\bootstrap\fn_postInit.sqf";
	//diag_log "Debug: Executing Exile server post init.";
};

true