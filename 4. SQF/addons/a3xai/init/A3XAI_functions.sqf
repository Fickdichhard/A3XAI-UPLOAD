/*
	A3XAI Functions

*/

diag_log "[A3XAI] Compiling A3XAI functions.";

call compile preprocessFile format ["%1\SHK_pos\A3XAI_SHK_pos_init.sqf",A3XAI_directory];

//A3XAI_behavior
A3XAI_BIN_taskPatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_BIN_taskPatrol.sqf",A3XAI_directory];
A3XAI_customHeliDetect = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_customHeliDetect.sqf",A3XAI_directory];
A3XAI_heliDetection = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_heliDetection.sqf",A3XAI_directory];
A3XAI_heliStartPatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_heliStartPatrol.sqf",A3XAI_directory];
A3XAI_hunterLocate = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_hunterLocate.sqf",A3XAI_directory];
A3XAI_huntKiller = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_huntKiller.sqf",A3XAI_directory];
A3XAI_reinforce_begin = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_reinforce_begin.sqf",A3XAI_directory];
A3XAI_vehCrewRegroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_vehCrewRegroup.sqf",A3XAI_directory];
A3XAI_vehCrewRegroupComplete = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_vehCrewRegroupComplete.sqf",A3XAI_directory];
A3XAI_vehStartPatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_vehStartPatrol.sqf",A3XAI_directory];
A3XAI_UAVStartPatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_UAVStartPatrol.sqf",A3XAI_directory];
A3XAI_UAVDetection = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_UAVDetection.sqf",A3XAI_directory];
A3XAI_UGVStartPatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_UGVStartPatrol.sqf",A3XAI_directory];
A3XAI_UGVDetection = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_UGVDetection.sqf",A3XAI_directory];
A3XAI_areaSearching = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_areaSearching.sqf",A3XAI_directory];
A3XAI_startHunting = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_startHunting.sqf",A3XAI_directory];
A3XAI_defensiveAggression = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_defensiveAggression.sqf",A3XAI_directory];
A3XAI_forceBehavior = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_behavior\A3XAI_forceBehavior.sqf",A3XAI_directory];

//A3XAI_unit_events
A3XAI_handle_death_UV = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handle_death_UV.sqf",A3XAI_directory];
A3XAI_handleDamageHeli = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDamageHeli.sqf",A3XAI_directory];
A3XAI_handleDamageVeh = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDamageVeh.sqf",A3XAI_directory];
A3XAI_handleDamageUnit = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDamageUnit.sqf",A3XAI_directory];
A3XAI_handleDamageUGV = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDamageUGV.sqf",A3XAI_directory];
A3XAI_handleDeath_air = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_air.sqf",A3XAI_directory];
A3XAI_handleDeath_air_reinforce = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_air_reinforce.sqf",A3XAI_directory];
A3XAI_handleDeath_aircrashed = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_aircrashed.sqf",A3XAI_directory];
A3XAI_handleDeath_aircustom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_aircustom.sqf",A3XAI_directory];
A3XAI_handleDeath_dynamic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_dynamic.sqf",A3XAI_directory];
A3XAI_handleDeath_generic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_generic.sqf",A3XAI_directory];
A3XAI_handleDeath_land = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_land.sqf",A3XAI_directory];
A3XAI_handleDeath_landcustom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_landcustom.sqf",A3XAI_directory];
A3XAI_handleDeath_random = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_random.sqf",A3XAI_directory];
A3XAI_handleDeath_static = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_static.sqf",A3XAI_directory];
A3XAI_handleDeath_staticcustom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_staticcustom.sqf",A3XAI_directory];
A3XAI_handleDeath_vehiclecrew = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeath_vehiclecrew.sqf",A3XAI_directory];
A3XAI_handleDeathEvent = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_handleDeathEvent.sqf",A3XAI_directory];
A3XAI_heliDestroyed = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_heliDestroyed.sqf",A3XAI_directory];
A3XAI_heliEvacuated = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_heliEvacuated.sqf",A3XAI_directory];
A3XAI_heliLanded = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_heliLanded.sqf",A3XAI_directory];
A3XAI_heliParaDrop = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_heliParaDrop.sqf",A3XAI_directory];
A3XAI_UAV_destroyed = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_UAV_destroyed.sqf",A3XAI_directory];
A3XAI_UGV_destroyed = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_UGV_destroyed.sqf",A3XAI_directory];
A3XAI_vehDestroyed = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_vehDestroyed.sqf",A3XAI_directory];
A3XAI_vehMPKilled = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_vehMPKilled.sqf",A3XAI_directory];
A3XAI_ejectParachute = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_events\A3XAI_ejectParachute.sqf",A3XAI_directory];

//A3XAI_unit_spawning
A3XAI_addRespawnQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_addRespawnQueue.sqf",A3XAI_directory];
A3XAI_addVehicleGunners = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_addVehicleGunners.sqf",A3XAI_directory];
A3XAI_cancelDynamicSpawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_cancelDynamicSpawn.sqf",A3XAI_directory];
A3XAI_cancelRandomSpawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_cancelRandomSpawn.sqf",A3XAI_directory];
A3XAI_create_UV_unit = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_create_UV_unit.sqf",A3XAI_directory];
A3XAI_createCustomSpawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_createCustomSpawn.sqf",A3XAI_directory];
A3XAI_createUnit = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_createUnit.sqf",A3XAI_directory];
A3XAI_despawn_dynamic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_despawn_dynamic.sqf",A3XAI_directory];
A3XAI_despawn_random = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_despawn_random.sqf",A3XAI_directory];
A3XAI_despawn_static = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_despawn_static.sqf",A3XAI_directory];
A3XAI_processRespawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_processRespawn.sqf",A3XAI_directory];
A3XAI_respawnGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_respawnGroup.sqf",A3XAI_directory];
A3XAI_setup_randomspawns = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_setup_randomspawns.sqf",A3XAI_directory];
A3XAI_spawn_reinforcement = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_spawn_reinforcement.sqf",A3XAI_directory];
A3XAI_spawn_UV_patrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_spawn_UV_patrol.sqf",A3XAI_directory];
A3XAI_spawnGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_spawnGroup.sqf",A3XAI_directory];
A3XAI_spawnInfantryCustom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_spawnInfantryCustom.sqf",A3XAI_directory];
A3XAI_spawnUnits_dynamic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_spawnUnits_dynamic.sqf",A3XAI_directory];
A3XAI_spawnUnits_random = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_spawnUnits_random.sqf",A3XAI_directory];
A3XAI_spawnUnits_static = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_spawnUnits_static.sqf",A3XAI_directory];
A3XAI_spawnVehicleCustom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_spawnVehicleCustom.sqf",A3XAI_directory];
A3XAI_spawnVehiclePatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_spawnVehiclePatrol.sqf",A3XAI_directory];
A3XAI_addVehicleGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_addVehicleGroup.sqf",A3XAI_directory];
A3XAI_addParaGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_addParaGroup.sqf",A3XAI_directory];
A3XAI_respawnAIVehicle = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_respawnAIVehicle.sqf",A3XAI_directory];
A3XAI_cleanupReinforcementGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_unit_spawning\A3XAI_cleanupReinforcementGroup.sqf",A3XAI_directory];

//A3XAI_utilities
A3XAI_addItem = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addItem.sqf",A3XAI_directory];
A3XAI_addLandVehEH = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addLandVehEH.sqf",A3XAI_directory];
A3XAI_addMapMarker = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addMapMarker.sqf",A3XAI_directory];
A3XAI_addTempNVG = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addTempNVG.sqf",A3XAI_directory];
A3XAI_addTemporaryWaypoint = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addTemporaryWaypoint.sqf",A3XAI_directory];
A3XAI_addToExternalObjectMonitor = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addToExternalObjectMonitor.sqf",A3XAI_directory];
A3XAI_addUAVEH = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addUAVEH.sqf",A3XAI_directory];
A3XAI_addUGVEH = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addUGVEH.sqf",A3XAI_directory];
A3XAI_addUnitEH = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addUnitEH.sqf",A3XAI_directory];
A3XAI_addUVUnitEH = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addUVUnitEH.sqf",A3XAI_directory];
A3XAI_addVehAirEH = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_addVehAirEH.sqf",A3XAI_directory];
A3XAI_chance = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_chance.sqf",A3XAI_directory];
A3XAI_checkClassname = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_checkClassname.sqf",A3XAI_directory];
A3XAI_checkInNoAggroArea = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_checkInNoAggroArea.sqf",A3XAI_directory];
A3XAI_checkIsWeapon = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_checkIsWeapon.sqf",A3XAI_directory];
A3XAI_clearVehicleCargo = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_clearVehicleCargo.sqf",A3XAI_directory];
A3XAI_countVehicleGunners = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_countVehicleGunners.sqf",A3XAI_directory];
A3XAI_createBlackListArea = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createBlackListArea.sqf",A3XAI_directory];
A3XAI_createBlackListAreaDynamic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createBlackListAreaDynamic.sqf",A3XAI_directory];
A3XAI_createBlackListAreaRandom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createBlackListAreaRandom.sqf",A3XAI_directory];
A3XAI_createNoAggroArea = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createNoAggroArea.sqf",A3XAI_directory];
A3XAI_createBlacklistAreaQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createBlacklistAreaQueue.sqf",A3XAI_directory];
A3XAI_createCustomInfantryQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createCustomInfantryQueue.sqf",A3XAI_directory];
A3XAI_createCustomInfantrySpawnQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createCustomInfantrySpawnQueue.sqf",A3XAI_directory];
A3XAI_createCustomVehicleQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createCustomVehicleQueue.sqf",A3XAI_directory];
A3XAI_createGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createGroup.sqf",A3XAI_directory];
A3XAI_createInfantryQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createInfantryQueue.sqf",A3XAI_directory];
A3XAI_createRandomInfantrySpawnQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_createRandomInfantrySpawnQueue.sqf",A3XAI_directory];
A3XAI_deleteGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_deleteGroup.sqf",A3XAI_directory];
A3XAI_deleteCustomSpawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_deleteCustomSpawn.sqf",A3XAI_directory];
A3XAI_findSpawnPos = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_findSpawnPos.sqf",A3XAI_directory];
A3XAI_fixStuckGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_fixStuckGroup.sqf",A3XAI_directory];
A3XAI_getNoAggroStatus = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_getNoAggroStatus.sqf",A3XAI_directory];
A3XAI_getSafePosReflected = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_getSafePosReflected.sqf",A3XAI_directory];
A3XAI_getSpawnParams = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_getSpawnParams.sqf",A3XAI_directory];
A3XAI_getUnitLevel = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_getUnitLevel.sqf",A3XAI_directory];
A3XAI_getWeapon = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_getWeapon.sqf",A3XAI_directory];
A3XAI_hasLOS = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_hasLOS.sqf",A3XAI_directory];
A3XAI_initializeTrigger = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_initializeTrigger.sqf",A3XAI_directory];
A3XAI_initNoAggroStatus = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_initNoAggroStatus.sqf",A3XAI_directory];
A3XAI_initUVGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_initUVGroup.sqf",A3XAI_directory];
A3XAI_moveToPosAndDeleteWP = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_moveToPosAndDeleteWP.sqf",A3XAI_directory];
A3XAI_moveToPosAndPatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_moveToPosAndPatrol.sqf",A3XAI_directory];
A3XAI_noAggroAreaToggle = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_noAggroAreaToggle.sqf",A3XAI_directory];
A3XAI_param = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_param.sqf",A3XAI_directory];
A3XAI_posInBuilding = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_posInBuilding.sqf",A3XAI_directory];
A3XAI_protectGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_protectGroup.sqf",A3XAI_directory];
A3XAI_protectObject = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_protectObject.sqf",A3XAI_directory];
A3XAI_purgeUnitGear = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_purgeUnitGear.sqf",A3XAI_directory];
A3XAI_radioSend = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_radioSend.sqf",A3XAI_directory];
A3XAI_releaseVehicleAllow = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_releaseVehicleAllow.sqf",A3XAI_directory];
A3XAI_releaseVehicleNow = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_releaseVehicleNow.sqf",A3XAI_directory];
A3XAI_reloadVehicleTurrets = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_reloadVehicleTurrets.sqf",A3XAI_directory];
A3XAI_removeExplosive = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_removeExplosive.sqf",A3XAI_directory];
A3XAI_returnNoAggroArea = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_returnNoAggroArea.sqf",A3XAI_directory];
A3XAI_secureVehicle = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_secureVehicle.sqf",A3XAI_directory];
A3XAI_sendKillResponse = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_sendKillResponse.sqf",A3XAI_directory];
A3XAI_setFirstWPPos = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_setFirstWPPos.sqf",A3XAI_directory];
A3XAI_setNoAggroStatus = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_setNoAggroStatus.sqf",A3XAI_directory];
A3XAI_setSkills = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_setSkills.sqf",A3XAI_directory];
A3XAI_setVehicleRegrouped = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_setVehicleRegrouped.sqf",A3XAI_directory];
A3XAI_updateSpawnCount = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_updateSpawnCount.sqf",A3XAI_directory];
A3XAI_updGroupCount = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_updGroupCount.sqf",A3XAI_directory];
A3XAI_selectRandom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_selectRandom.sqf",A3XAI_directory];
A3XAI_setRandomWaypoint = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_setRandomWaypoint.sqf",A3XAI_directory];
A3XAI_getPosBetween = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_getPosBetween.sqf",A3XAI_directory];
A3XAI_debugMarkerLocation = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_debugMarkerLocation.sqf",A3XAI_directory];
A3XAI_sendExileMessage = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_utilities\A3XAI_sendExileMessage.sqf",A3XAI_directory];

//Group functions
A3XAI_getLocalFunctions = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_getLocalFunctions.sqf",A3XAI_directory];
A3XAI_getAntistuckTime = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_getAntistuckTime.sqf",A3XAI_directory];
A3XAI_setLoadoutVariables = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_setLoadoutVariables.sqf",A3XAI_directory];
A3XAI_execEveryLoop_air = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_execEveryLoop_air.sqf",A3XAI_directory];
A3XAI_execEveryLoop_infantry = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_execEveryLoop_infantry.sqf",A3XAI_directory];
A3XAI_execEveryLoop_vehicle = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_execEveryLoop_vehicle.sqf",A3XAI_directory];
A3XAI_execEveryLoop_ugv = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_execEveryLoop_ugv.sqf",A3XAI_directory];
A3XAI_execEveryLoop_uav = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_execEveryLoop_uav.sqf",A3XAI_directory];
A3XAI_checkGroupUnits = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_checkGroupUnits.sqf",A3XAI_directory];
A3XAI_generateGroupLoot = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_generateGroupLoot.sqf",A3XAI_directory];
A3XAI_checkAmmoFuel = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_checkAmmoFuel.sqf",A3XAI_directory];
A3XAI_antistuck_air = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_antistuck_air.sqf",A3XAI_directory];
A3XAI_antistuck_aircustom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_antistuck_aircustom.sqf",A3XAI_directory];
A3XAI_antistuck_generic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_antistuck_generic.sqf",A3XAI_directory];
A3XAI_antistuck_land = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_antistuck_land.sqf",A3XAI_directory];
A3XAI_antistuck_uav = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_antistuck_uav.sqf",A3XAI_directory];
A3XAI_antistuck_ugv = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_antistuck_ugv.sqf",A3XAI_directory];
A3XAI_generateLootPool = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_generateLootPool.sqf",A3XAI_directory];
A3XAI_generateLootOnDeath = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_generateLootOnDeath.sqf",A3XAI_directory];
A3XAI_generateLoadout = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_generateLoadout.sqf",A3XAI_directory];
A3XAI_addGroupManager = compileFinal preprocessFileLineNumbers format ["%1\compile\A3XAI_group_functions\A3XAI_addGroupManager.sqf",A3XAI_directory];

diag_log "[A3XAI] A3XAI functions compiled.";

true
