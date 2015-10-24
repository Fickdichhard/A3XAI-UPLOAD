//A3XAI Editor Tool Version 1.1.2

[] spawn {
	waitUntil {player == player};
	
	player allowDamage false;
	player setCaptive true;
	["Teleport",  "onMapSingleClick" , {if (!(surfaceIsWater _pos) && {!_shift}) then {vehicle player setPos _pos; openMap false;}; true}] call BIS_fnc_addStackedEventHandler; 
	if !("ItemGPS" in assignedItems player) then {player addItem "ItemGPS"; player assignItem "ItemGPS";};
	A3XAI_ruler50m = createMarker ["Ruler50m", getPosASL player];
	A3XAI_ruler50m setMarkerShape "ELLIPSE";
	A3XAI_ruler50m setMarkerType "Circle";
	A3XAI_ruler50m setMarkerBrush "Border";
	A3XAI_ruler50m setMarkerSize [50,50];
	A3XAI_ruler100m = createMarker ["Ruler100m", getPosASL player];
	A3XAI_ruler100m setMarkerShape "ELLIPSE";
	A3XAI_ruler100m setMarkerType "Circle";
	A3XAI_ruler100m setMarkerBrush "Border";
	A3XAI_ruler100m setMarkerSize [100,100];
	A3XAI_ruler200m = createMarker ["Ruler200m", getPosASL player];
	A3XAI_ruler200m setMarkerShape "ELLIPSE";
	A3XAI_ruler200m setMarkerType "Circle";
	A3XAI_ruler200m setMarkerBrush "Border";
	A3XAI_ruler200m setMarkerSize [200,200];
	A3XAI_ruler300m = createMarker ["Ruler300m", getPosASL player];
	A3XAI_ruler300m setMarkerShape "ELLIPSE";
	A3XAI_ruler300m setMarkerType "Circle";
	A3XAI_ruler300m setMarkerBrush "Border";
	A3XAI_ruler300m setMarkerSize [300,300];
	
	if (isNil "playerMarkerUpdate") then {
		playerMarkerUpdate = true;
		_nul = [] spawn {
			while {true} do {
				A3XAI_ruler50m setMarkerPos (getPosASL player);
				A3XAI_ruler100m setMarkerPos (getPosASL player);
				A3XAI_ruler200m setMarkerPos (getPosASL player);
				A3XAI_ruler300m setMarkerPos (getPosASL player);
				uiSleep 1;
			};
		};
	};
	//playerMarker setMarkerAlpha 0;

	currentEditorMode = "Infantry";
	generateUnitsStatement = format ["['AreaName1',%1,%2,%3,%4,%5] call A3XAI_generateArea;",100,2,1,true,600];
	copyToClipboard generateUnitsStatement;
	
	generateVehiclesStatement = format ["['AreaName1','VehicleType',%1,%2,%3,%4,%5] call A3XAI_generateArea;",100,[1,1],1,true,600];
	
	generateBlacklistStatement = format ["['AreaName1',%1] call A3XAI_generateArea;",100];
	
	editorHelpStatement = parseText format ["
			
		To start creating custom spawns, use the A3XAI_generateArea function and the Debug Console. An example has been copied to your clipboard.
		<br/>
		<br/>Change editing modes using the scroll-wheel options.
		<br/>
		<br/>Single-click on the map to teleport to a new location.
		
	"];
	
	hintSilent editorHelpStatement;
	
	if (isNil "A3XAI_customSpawnUnitAction") then {
		A3XAI_customSpawnUnitAction = true;
		player addAction ["Editor Mode: Custom Infantry",'
			currentEditorMode = "Infantry";
			copyToClipboard generateUnitsStatement;
			titleText ["Changed Editor Mode: Custom Infantry Spawn. Template statement copied to clipboard.","plain down"];
		'];
	};
	
	if (isNil "A3XAI_customVehiclesAction") then {
		A3XAI_customVehiclesAction = true;
		player addAction ["Editor Mode: Custom Vehicles",'
			currentEditorMode = "Vehicles";
			copyToClipboard generateVehiclesStatement;
			titleText ["Changed Editor Mode: Custom Vehicle Spawn. Template statement copied to clipboard.","plain down"];
		'];
	};
	
	if (isNil "A3XAI_areaBlacklistAction") then {
		A3XAI_areaBlacklistAction = true;
		player addAction ["Editor Mode: Area Blacklists",'
			currentEditorMode = "Blacklists";
			copyToClipboard generateBlacklistStatement;
			titleText ["Changed Editor Mode: Area Blacklist. Template statement copied to clipboard.","plain down"];
		'];
	};
	
	if (isNil "A3XAI_exportSpawns") then {
		A3XAI_exportSpawns = true;
		player addAction ["Export Spawn Configs",'
			copyToClipboard A3XAI_spawnsGenerated;
			titleText ["Successfully exported custom spawn configs to clipboard.","plain down"];
		'];
	};
	
	if (isNil "A3XAI_getHelp") then {
		A3XAI_getHelp = true;
		player addAction ["Display Help",'
			hintSilent editorHelpStatement;
		'];
		
	};

	if (isNil "A3XAI_generateArea") then {
		A3XAI_spawnsIndex = [];
		A3XAI_spawnsGenerated = "";
		A3XAI_lineBreak = toString [13,10];
		A3XAI_generateArea = compileFinal '
		_spawnName = str(_this select 0);
		_spawnPos = getPosATL player;
		_statement = "";
			if !(_spawnName in A3XAI_spawnsIndex) then {
			
			//playerMarker setMarkerPos _spawnPos;
		
			call {
				if (currentEditorMode == "Infantry") exitWith {
					_patrolRadius = if ((count _this) > 1) then {if ((typeName (_this select 1)) == "SCALAR") then {_this select 1} else {100}} else {100};
					_totalAI = if ((count _this) > 2) then {if ((typeName (_this select 2)) == "SCALAR") then {_this select 2} else {1}} else {1};
					_unitLevel = if ((count _this) > 3) then {if ((typeName (_this select 3)) == "SCALAR") then {_this select 3} else {1}} else {1};
					_respawn = if ((count _this) > 4) then {if ((typeName (_this select 4)) == "BOOL") then {_this select 4} else {true}} else {true};
					_respawnTime = if ((count _this) > 5) then {if ((typeName (_this select 5)) == "SCALAR") then {_this select 5} else {0}} else {0};
					
					if (_patrolRadius > 300) then {_patrolRadius = 300;};
					
					_statement = format ["[%1,%2,%3,%4,%5,%6,%7] call A3XAI_createCustomInfantryQueue;",_spawnName,_spawnPos,_patrolRadius,_totalAI,_unitLevel,_respawn,_respawnTime];
				};
				if (currentEditorMode == "Vehicles") exitWith {
					_vehicleType = str(_this select 1);
					_patrolRadius = if ((count _this) > 2) then {_this select 2} else {100};
					_maxUnits = if ((count _this) > 3) then {_this select 3} else {[1,1]};
					_unitLevel = if ((count _this) > 4) then {_this select 4} else {1};
					_respawn = if ((count _this) > 5) then {if ((typeName (_this select 5)) == "BOOL") then {_this select 5} else {false}} else {false};
					_respawnTime = if ((count _this) > 6) then {if ((typeName (_this select 6)) == "SCALAR") then {_this select 6} else {0}} else {0};
					
					//playerMarker setMarkerSize [_patrolRadius,_patrolRadius];
					
					_statement = format ["[%1,%2,%3,%4,%5,%6,%7,%8] call A3XAI_createCustomVehicleQueue;",_spawnName,_spawnPos,_vehicleType,_patrolRadius,_maxUnits,_unitLevel,_respawn,_respawnTime];
				};
				if (currentEditorMode == "Blacklists") exitWith {
					_areaRadius = _this select 1;

					if (_areaRadius > 1499) then {_areaRadius = 1499;};
					
					_statement = format ["[%1,%2,%3] call A3XAI_createBlacklistAreaQueue;",_spawnName,_spawnPos,_areaRadius];
				};
			};
			A3XAI_spawnsIndex pushBack _spawnName;
			A3XAI_spawnsGenerated = A3XAI_spawnsGenerated + _statement + A3XAI_lineBreak;
			copyToClipboard A3XAI_spawnsGenerated;
			
			hintSilent parseText format ["
			
				Generated custom spawn with name %1
				<br/>
				<br/>To add your custom spawns to A3XAI, paste clipboard contents to @ExileServer\custom_spawn_defs.sqf
				
			",_spawnName];
			hintSilent format ["Total custom spawns generated and saved: %1.",(count A3XAI_spawnsIndex)];
			diag_log format ["Custom spawn %1 generated and saved to clipboard: %2",_spawnName,_statement];
			diag_log "To add your custom spawns to A3XAI, paste clipboard contents to @ExileServer\custom_spawn_defs.sqf";
		} else {
			hintSilent format ["Error: Custom spawn with name %1 already exists. Please use another name.",_spawnName];
			diag_log format ["Error: Custom spawn with name %1 already exists. Please use another name.",_spawnName];
		};
		
		A3XAI_spawnsGenerated
		';
	};
};