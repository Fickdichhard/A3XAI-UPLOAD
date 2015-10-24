class CfgPatches {
	class A3XAI {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		A3XAIVersion = "0.2.1";
		compatibleConfigVersions[] = {"0.2.0","0.2.0a","0.2.0b","0.2.0c","0.2.1"};
		compatibleHCVersions[] = {"0.2.1"};
		requiredAddons[] = {"exile_client"};
	};
	class A3XAI_HC {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		A3XAI_HCVersion = "0.2.1";
		requiredAddons[] = {"exile_client"};
	};
};

class CfgFunctions {
	class A3XAI {
		class A3XAI_Server {
			file = "A3XAI";
			
			class A3XAI_init {
				preInit = 1;
			};
		};
	};
	
	class ExileClient {
		class Bootstrap {
			file = "\A3XAI\init\client";
			
			class preInit {
				preInit = 1;
			};
			
			class postInit {
				postInit = 1;
			};
		};
	};
	
	class ExileServer {
		class Bootstrap {
			file = "\A3XAI\init\server";
			
			class preInit {
				preInit = 1;
			};
			
			class postInit {
				postInit = 1;
			};
		};
	};
};

class CfgNonAIVehicles {
	class A3XAI_EmptyDetector {
		displayName="A3XAI Trigger";
		icon = "\a3\Ui_f\data\IGUI\Cfg\IslandMap\iconSensor_ca.paa";
		model = "";
		scope = public;
		selectionFabric = "latka";
		simulation="detector";
	};
};

class CfgLocationTypes {
	class A3XAI_BlacklistedArea {
		color[] = {0.91,0,0,1};
		drawStyle = "name";
		font = "PuristaMedium";
		name = "A3XAI Blacklist Area";
		shadow = 1;
		size = 15;
		textSize = 0.05;
		texture = "";
	};
	class A3XAI_NoAggroArea {
		color[] = {0.91,0,0,1};
		drawStyle = "name";
		font = "PuristaMedium";
		name = "A3XAI No-Aggro Area";
		shadow = 1;
		size = 15;
		textSize = 0.05;
		texture = "";
	};
	class A3XAI_RandomSpawnArea {
		color[] = {0.91,0,0,1};
		drawStyle = "name";
		font = "PuristaMedium";
		name = "A3XAI Random Spawn Area";
		shadow = 1;
		size = 15;
		textSize = 0.05;
		texture = "";
	};
	class A3XAI_DynamicSpawnArea {
		color[] = {0.91,0,0,1};
		drawStyle = "name";
		font = "PuristaMedium";
		name = "A3XAI Dynamic Spawn Area";
		shadow = 1;
		size = 15;
		textSize = 0.05;
		texture = "";
	};
};
