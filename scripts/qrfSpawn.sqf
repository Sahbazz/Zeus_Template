/*
	Author: 2600K / Josef Zemanek

	Description:
	Enemy Reinforcements Spawner
	
	_nul = [getMarkerPos "Objective"] execVM "scripts\qrfSpawn.sqf";
	
	Any marker containing text 'safezone' will not spawn units.
	Any marker containing text 'spawn' will act as an additional spawn point.
*/

if !isServer exitWith {};

params [
	"_location",		// Hunt/Search location.
	["_delay", 300],	// Seconds between waves.
	["_waveMax",6],		// Maximum Wave #
	["_spawnDist",1500]	// Spawning Distance
];

switch (typeName _location) do {
	case "STRING": {_location = getMarkerPos _location};
	case "OBJECT": {_location = getPos _location};
};

if !(_location isEqualType []) exitWith { systemChat "[QRF] ERROR Invalid Object/Position"; diag_log text "[QRF] ERROR Invalid Object/Position"; };

// Configuration - Pick ONE side.

/*

**********************
*** VANILLA GROUPS ***
**********************

// WEST - NATO TANOA (VANILLA)
_side = WEST;
_Soldier = ["B_T_Soldier_F","B_T_soldier_LAT_F","B_T_soldier_AR_F","B_T_Soldier_TL_F"];
_Sentry = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSentry"];
_Team = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfTeam"];
_Squad = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSquad"];
_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Motorized" >> "B_T_MotInf_Reinforcements"];
_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
_Medium = [["B_T_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_T_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
_Heavy = [["B_T_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
_Air = ["B_Heli_Light_01_F",["B_Heli_Transport_01_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"],"B_Heli_Transport_03_F"];
_CAS = ["B_Heli_Light_01_dynamicLoadout_F",["B_Heli_Attack_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_12Rnd_missiles'];_grpVeh setPylonLoadout [4,'PylonRack_12Rnd_missiles'];"],["B_Plane_CAS_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_7Rnd_Rocket_04_HE_F'];_grpVeh setPylonLoadout [4,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [5,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [6,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [7,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [8,'PylonRack_7Rnd_Rocket_04_AP_F'];"]];

// WEST - NATO (VANILLA)
_side = WEST;
_Soldier = ["B_Soldier_F","B_soldier_LAT_F","B_soldier_AR_F","B_Soldier_TL_F"];
_Sentry = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSentry"];
_Team = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam"];
_Squad = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad"];
_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Motorized" >> "BUS_MotInf_Reinforce"];
_Light = ["B_MRAP_01_gmg_F","B_MRAP_01_hmg_F","B_LSV_01_AT_F","B_LSV_01_armed_F"];
_Medium = [["B_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
_Heavy = [["B_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
_Air = ["B_Heli_Light_01_F","B_Heli_Transport_01_F",["B_Heli_Transport_03_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
_CAS = ["B_Heli_Light_01_dynamicLoadout_F",["B_Heli_Attack_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_12Rnd_missiles'];_grpVeh setPylonLoadout [4,'PylonRack_12Rnd_missiles'];"],["B_Plane_CAS_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_7Rnd_Rocket_04_HE_F'];_grpVeh setPylonLoadout [4,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [5,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [6,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [7,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [8,'PylonRack_7Rnd_Rocket_04_AP_F'];"]];

// WEST - FIA (VANILLA)
_side = WEST;
_Soldier = ["B_G_Soldier_LAT_F","B_G_Soldier_F","B_G_Soldier_SL_F","B_G_Soldier_AR_F"];
_Sentry = [configFile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "B_G_InfTeam_Light"];
_Team = [configFile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "B_G_InfTeam_Light"];
_Squad = [configFile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "B_G_InfSquad_Assault"];
_Truck = ["B_G_Van_01_transport_F"];
_Light = ["B_G_Offroad_01_AT_F","B_G_Offroad_01_armed_F"];
_Medium = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.7]] call BIS_fnc_initVehicle;"]];
_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
_CAS = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];

// WEST - GENDARME (VANILLA)
_side = WEST;
_Soldier = ["B_GEN_Soldier_F","B_GEN_Commander_F"];
_Sentry = [configFile >> "CfgGroups" >> "West" >> "Gendarmerie" >> "Infantry" >> "GENDARME_Inf_Patrol"];
_Team = [configFile >> "CfgGroups" >> "West" >> "Gendarmerie" >> "Infantry" >> "GENDARME_Inf_Patrol"];
_Squad = [configFile >> "CfgGroups" >> "West" >> "Gendarmerie" >> "Infantry" >> "GENDARME_Inf_Patrol"];
_Truck = ["B_GEN_Van_02_transport_F"];
_Light = [["B_G_Offroad_01_armed_F","[_grpVeh,false,['HideDoor1',0,'HideDoor2',0,'HideDoor3',0,'HideBackpacks',1,'HideBumper1',0,'HideBumper2',1,'HideConstruction',0]] call BIS_fnc_initVehicle;_grpVeh setObjectTextureGlobal [0,'\A3\Soft_F_Exp\Offroad_01\Data\Offroad_01_ext_gen_CO.paa']"]];
_Medium =[["O_MRAP_02_hmg_F","_grpVeh setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.7,0.8,1,0.03)'];_grpVeh setObjectTextureGlobal [1,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [2,'#(rgb,8,8,3)color(1,1,1,0.01)'];"]];
_Heavy = [["O_T_APC_Wheeled_02_rcws_ghex_F","_grpVeh setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.7,0.8,1,0.03)'];_grpVeh setObjectTextureGlobal [1,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [2,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [4,'#(rgb,8,8,3)color(0,0,0,1)'];"]];
_Air = [["I_Heli_Transport_02_F","_grpVeh setObjectTextureGlobal [0,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_1_ion_co.paa'];_grpVeh setObjectTextureGlobal [1,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_2_ion_co.paa'];_grpVeh setObjectTextureGlobal [2,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_3_ion_co.paa'];"]];
_CAS = [];

// EAST - CSAT TANOA (VANILLA)
_side = EAST;
_Soldier = ["O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_GL_F","O_T_Soldier_AR_F"];
_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSentry"];
_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam"];
_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Motorized_MTP" >> "O_T_MotInf_Reinforcements"];
_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
_Medium = [["O_T_APC_Wheeled_02_rcws_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_T_APC_Tracked_02_cannon_ghex_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["O_T_APC_Tracked_02_AA_ghex_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_02_cannon_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Air = [["O_Heli_Light_02_unarmed_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"],["O_Heli_Transport_04_bench_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
_CAS = ["O_T_VTOL_02_infantry_dynamicLoadout_F",["O_Heli_Light_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],["O_Heli_Attack_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle; _grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],"O_Plane_CAS_02_dynamicLoadout_F"];

// EAST - CSAT (VANILLA)
_side = EAST;
_Soldier = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_GL_F","O_Soldier_AR_F"];
_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry"];
_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam"];
_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized" >> "OIA_MotInf_Reinforce"];
_Light = ["O_MRAP_02_hmg_F","O_LSV_02_armed_F"];
_Medium = [["O_APC_Wheeled_02_rcws_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_APC_Tracked_02_cannon_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["O_APC_Tracked_02_AA_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_02_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
_CAS = [["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],["O_Heli_Attack_02_dynamicLoadout_F", "_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],"O_Plane_CAS_02_dynamicLoadout_F"];

// EAST - FIA (VANILLA)
_side = EAST;
_Soldier = ["O_G_Soldier_SL_F","O_G_Soldier_AR_F","O_G_Soldier_LAT_F","O_G_Soldier_F"];
_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfTeam_Light"];
_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfTeam_Light"];
_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfSquad_Assault"];
_Truck = ["O_G_Van_01_transport_F"];
_Light = ["O_G_Offroad_01_armed_F","O_G_Offroad_01_AT_F"];
_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
_CAS = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];

// GUER - SYNDIKAT (VANILLA)
_side = INDEPENDENT;
_Soldier = ["I_C_Soldier_Para_7_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_2_F"];
_Truck = ["I_C_Van_01_transport_F"];
_Light = ["I_C_Offroad_02_LMG_F","I_C_Offroad_02_AT_F"];
_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Air = ["I_Heli_light_03_unarmed_F"];
_CAS = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],TRUE] call BIS_fnc_initVehicle;"]];

// GUER - AAF (VANILLA)
_side = INDEPENDENT;
_Soldier = ["I_Soldier_F","I_Soldier_LAT_F","I_Soldier_GL_F","I_Soldier_AR_F"];
_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSentry"];
_Team = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam"];
_Squad = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad"];
_Truck = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Motorized" >> "HAF_MotInf_Reinforce"];
_Light = ["I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"];
_Medium = [["I_LT_01_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_APC_Wheeled_03_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_APC_tracked_03_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3,'showSLATHull',0.5,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Heavy = [["I_MBT_03_cannon_F","[_grpVeh,false,['HideTurret',0.3,'HideHull',0.3,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Air = [["I_Heli_light_03_unarmed_F","[_grpVeh,['Indep',1]] call BIS_fnc_initVehicle;"],"I_Heli_Transport_02_F", ["O_Heli_Light_02_unarmed_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa'];"], ["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0,'A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa'];"]];
_CAS = ["I_Heli_light_03_dynamicLoadout_F","I_Plane_Fighter_03_dynamicLoadout_F",["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa']; _grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"]];

********************
*** ADDON GROUPS ***
********************

// WEST - CDF (RHS)
_side = WEST;
_Soldier = ["rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_grenadier_rpg"];
_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhsgref_group_cdf_b_reg_infantry" >> "rhsgref_group_cdf_b_reg_infantry_squad"];
_Team = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhsgref_group_cdf_b_reg_infantry" >> "rhsgref_group_cdf_b_reg_infantry_squad"];
_Squad = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhsgref_group_cdf_b_reg_infantry" >> "rhsgref_group_cdf_b_reg_infantry_squad"];
_Truck = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_gaz66" >> "rhs_group_cdf_b_gaz66_squad", configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_ural" >> "rhs_group_cdf_b_ural_squad"];
_Light = ["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9"];
_Medium = ["rhsgref_cdf_b_btr70","rhsgref_cdf_b_bmp2k","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd2k"];
_Heavy = ["rhsgref_cdf_b_zsu234","rhsgref_cdf_b_t72bb_tv"];
_Air = ["rhsgref_cdf_b_reg_Mi8amt","rhsgref_cdf_b_reg_Mi17Sh"];
_CAS = ["rhsgref_cdf_b_Mi35","rhsgref_cdf_b_su25"];

// WEST - US ARMY D (RHS)
_side = WEST;
_Soldier = ["rhsusf_army_ocp_rifleman","rhsusf_army_ocp_machinegunner","rhsusf_army_ocp_grenadier","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_squadleader"];
_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_team"];
_Team = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_team"];
_Squad = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_squad"];
_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_squad"];
_Light = ["rhsusf_m1025_d_m2","rhsusf_m1025_d_Mk19"];
_Medium = ["rhsusf_m113d_usarmy","rhsusf_m113d_usarmy_MK19"];
_Heavy = ["RHS_M2A3","RHS_M6","rhsusf_m1a1aimd_usarmy"];
_Air = ["RHS_UH60M2_d","RHS_UH60M_d","RHS_MELB_MH6M"];
_CAS = ["RHS_MELB_AH6M","RHS_AH64DGrey","RHS_AH1Z"];

// WEST - US ARMY W (RHS)
_side = WEST;
_Soldier = ["rhsusf_army_ucp_rifleman","rhsusf_army_ucp_machinegunner","rhsusf_army_ucp_grenadier","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_squadleader"];
_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_team"];
_Team = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_team"];
_Squad = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_squad"];
_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_squad"];
_Light = ["rhsusf_m1025_w_m2","rhsusf_m1025_w_Mk19"];
_Medium = ["rhsusf_m113_usarmy","rhsusf_m113_usarmy_MK19"];
_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
_CAS = ["RHS_MELB_AH6M","RHS_AH64D_wd"];

// WEST - HORIZON (RHS)
_side = WEST;
_Soldier = ["rhsgref_hidf_grenadier","rhsgref_hidf_squadleader","rhsgref_hidf_autorifleman"];
_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_hidf" >> "rhsgref_group_hidf_infantry" >> "rhs_group_hidf_infantry_team"];
_Team = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_hidf" >> "rhsgref_group_hidf_infantry" >> "rhs_group_hidf_infantry_team"];
_Squad = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_hidf" >> "rhsgref_group_hidf_infantry" >> "rhsgref_group_hidf_infantry_squad"];
_Truck = ["rhsgref_hidf_m998_4dr"];
_Light = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025_mk19"];
_Medium = ["rhsgref_hidf_m113a3_m2","rhsgref_hidf_m113a3_mk19"];
_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
_CAS = ["RHS_MELB_AH6M","RHS_AH64D_wd"];

// EAST - RU MSV (RHS)
_side = EAST;
_Soldier = ["rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_rifleman","rhs_msv_LAT","rhs_msv_rifleman","rhs_msv_grenadier_rpg","rhs_msv_rifleman","rhs_msv_machinegunner"];
_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_MANEUVER"];
_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_fireteam"];
_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_squad"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
_Medium = ["rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
_CAS = ["RHS_Mi24P_vvsc","RHS_Ka52_vvsc"];

// EAST - RU DESERT (RHS)
_side = EAST;
_Soldier = ["rhs_vdv_mflora_rifleman","rhs_vdv_mflora_at","rhs_vdv_mflora_grenadier","rhs_vdv_mflora_sergeant","rhs_vdv_mflora_machinegunner"];
_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora"];
_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora"];
_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora"];
_Truck = [["RHS_Ural_VDV_01","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
_Light = [["RHS_Ural_Zu23_VDV_01","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
_Medium = [["rhs_bmd2","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1k_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
_Heavy = [["rhs_t72bc_tv","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"], ["rhs_zsu234_aa","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
_CAS = [["RHS_Mi24V_vvs","_grpVeh setPylonLoadout [5,'']; _grpVeh setPylonLoadout [6,''];"]];

// EAST - TAKI (ZEU)
_side = EAST;
_Soldier = ["O_Taki_soldier_TL_F","O_Taki_soldier_R26_F","O_Taki_soldier_R_AK103_F","O_Taki_soldier_R_AK105_F"];
_Sentry = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_Sentry"];
_Team = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_AssaultTeam"];
_Squad = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_RifleSquad"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Motorized" >> "Taki_MountedWarband"];
_Light = ["Taki_Ural_Zu23_F","Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F"];
_Medium = ["Taki_bmd1_F","Taki_bmp1_F"];
_Heavy = ["Taki_t72_F", "Taki_zsu_F"];
_Air = ["Taki_mi8_armed_F"];
_CAS = ["Taki_mi8_armed_F"];

// GUER - SAF (RHS)
_side = INDEPENDENT;
_Soldier = ["rhssaf_army_m93_oakleaf_summer_spec_aa","rhssaf_army_m93_oakleaf_summer_spec_at","rhssaf_army_m93_oakleaf_summer_sq_lead","rhssaf_army_m93_oakleaf_summer_ft_lead","rhssaf_army_m93_oakleaf_summer_rifleman_m70","rhssaf_army_m93_oakleaf_summer_mgun_m84","rhssaf_army_m93_oakleaf_summer_gl","rhssaf_army_m93_oakleaf_summer_rifleman_at"];
_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> "rhsgref_group_chdkz_infantry_mg"];
_Team = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> "rhsgref_group_chdkz_infantry_patrol"];
_Squad = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> "rhsgref_group_chdkz_ins_gurgents_squad"];
_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
_Light = ["rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9","rhsgref_nat_uaz_dshkm"];
_Medium = ["rhsgref_nat_btr70"];
_Heavy = ["rhsgref_ins_g_bmp1k"];
_Air = ["rhsgref_ins_g_Mi8amt"];
_CAS = ["Taki_mi8_armed_F"];

// GUER - REBELS (RHS)
_side = INDEPENDENT;
_Soldier = ["rhsgref_ins_g_rifleman","rhsgref_ins_g_machinegunner","rhsgref_ins_g_grenadier","rhsgref_ins_g_rifleman_RPG26"];
_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> "rhsgref_group_chdkz_infantry_mg"];
_Team = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> "rhsgref_group_chdkz_infantry_patrol"];
_Squad = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> "rhsgref_group_chdkz_ins_gurgents_squad"];
_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
_Light = ["rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_ins_g_uaz_spg9"];
_Medium = ["rhsgref_ins_g_btr70"];
_Heavy = ["rhsgref_ins_g_bmd1","rhsgref_ins_g_bmp1","rhsgref_ins_g_zsu234"];
_Air = ["Taki_mi8_armed_F"];
_CAS = ["Taki_mi8_armed_F"];

*/

// Functions.
ZRF_fnc_CreateReinforcements = {
	params [
		"_targetPos",
		"_posArray",
		"_side",
		"_unitClass"
	];
	_reinfGrp = grpNull;
	_grpVeh = objNull;
	_vehType = "";
	_sleep = TRUE;
	_tooClose = FALSE;
	_dir = 0;
	_customInit = "";
	
	// No positions to use
	if (count _posArray == 0) exitWith {};
	
	// Fix any positions are not in array format
	{
		switch (typeName _x) do {
			case "STRING": { _posArray set [_forEachIndex, getMarkerPos _x] };
			case "OBJECT": { _posArray set [_forEachIndex, getPos _x] };
		};
	} forEach _posArray;
	
	_startingPos = selectRandom _posArray;
	_startingPos set [2,0];
	_dir = _startingPos getDir _targetPos;
	_manArray = missionNamespace getVariable [format["ZRF_%1Soldier", _side], ["B_Soldier_F"]];
	
	// If _unitClass is array, extract the custom init.
	if (_unitClass isEqualType []) then {
		_customInit = _unitClass select 1;
		_unitClass = _unitClass select 0;
	};
	
	// Check if _unitClass is an air vehicle.
	_isAir = FALSE;
	if (_unitClass isEqualType "") then {
		if ("Air" in ([(configFile >> "CfgVehicles" >> _unitClass), TRUE] call BIS_fnc_returnParents)) then { _isAir = TRUE };
	};
	
	// Don't spawn object if too close to any players.
	_maxDist = if _isAir then {1000} else {500};
	{
		if (alive _x && _x distance2D _startingPos < _maxDist) exitWith { _tooClose = true};
	} forEach (playableUnits + switchableUnits);
	
	if _tooClose exitWith { [_targetPos, _posArray, _side, _unitClass] spawn ZRF_fnc_CreateReinforcements };
	
	if (_unitClass isEqualType "") then {
		_vehType = toLower getText (configFile >> "CfgVehicles" >> _unitClass >> "vehicleClass");
		_veh = createVehicle [_unitClass, _startingPos, [], 0, if _isAir then {"FLY"} else {"NONE"}];
		_veh setVehicleLock "LOCKEDPLAYER"; 
	
		if _isAir then {
			_sleep = FALSE;
			_veh setDir (_veh getDir _targetPos);
		} else {
			_veh setDir _dir;
		};
		
		if (_vehType == "car") then {
			_soldierArr = [];
		
			for [{_i = 1}, {_i <= count (fullCrew [_veh, "", true])}, {_i = _i + 1}] do {
				_soldierArr pushBack (selectRandom _manArray);
			};
		
			_reinfGrp = [[_veh, 15, random 360] call BIS_fnc_relPos, _side, _soldierArr] call BIS_fnc_spawnGroup;
			_grpVeh = _veh;
			_reinfGrp addVehicle _grpVeh;
			_wp = _reinfGrp addWaypoint [position _veh, 0];
			_wp setWaypointType "GETIN NEAREST";
		} else {
			createVehicleCrew _veh;
			
			// Convert crew if using another faction vehicle.
			if (([getNumber (configFile >> "CfgVehicles" >> _unitClass >> "Side")] call BIS_fnc_sideType) != _side) then {
				_reinfGrp = createGroup [_side, true];
				(crew _veh) join _reinfGrp;
			};
			
			_reinfGrp = group effectiveCommander _veh;
			_grpVeh = vehicle leader _reinfGrp;
		};
	} else {
		_reinfGrp = [_startingPos, _side, _unitClass] call BIS_fnc_spawnGroup;
		_grpVeh = (position leader _reinfGrp) nearestObject "Car";
		
		if (leader _reinfGrp distance2D _grpVeh < 75) then {
			_vehType = "car";
			{unassignVehicle _x; [_x] orderGetIn FALSE} forEach units _reinfGrp;
			_reinfGrp addVehicle _grpVeh;	
			_wp = _reinfGrp addWaypoint [position _grpVeh, 0];
			_wp setWaypointType "GETIN NEAREST";
		};
	};
	
	// Exclude group from caching
	_reinfGrp setVariable ["f_cacheExcl", true];
	// Run custom init for vehicle (set camos etc).
	if !(_customInit isEqualTo "") then { call compile _customInit; };
	
	if !_isAir then {
		_newWP = _reinfGrp addWaypoint [_targetPos, 100];
		_newWP setWaypointType "SAD";
	
		_newWP = _reinfGrp addWaypoint [_targetPos, 100];
		_newWP setWaypointType "GUARD";
		
		if (_vehType == "car") then {
			_null = [_reinfGrp, _startingPos, _grpVeh, _targetPos] spawn {
				params ["_selGrp", "_startPos", "_selVeh", "_destPos"];

				_leader = leader _selGrp;
							
				waitUntil{sleep 15; if (_leader distance2D _destPos < 400 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
				
				if (!alive _leader || !canMove _selVeh) exitWith {};
				
				[_leader] joinSilent grpNull;
				_newGrp = group _leader;
				
				[commander _selVeh] joinSilent (group _leader);
				[gunner _selVeh] joinSilent (group _leader);
				
				_selGrp leaveVehicle _selVeh;
				{unassignVehicle _x; [_x] orderGetIn FALSE; _x allowFleeing 0} forEach units _selGrp;
				
				waitUntil{sleep 1; if ({vehicle _x == _selVeh} count units _selGrp == 0 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
				
				if (!alive _leader || !canMove _selVeh) exitWith {};
				
				_leader assignAsDriver _selVeh;
				[_leader] orderGetIn TRUE;
				
				if (vehicle _leader == _selVeh) then {
					_leader setPos position _selVeh;
					_leader moveInDriver _selVeh;
				};
				
				sleep 20;
				
				if (canFire _selVeh) then {
					_newWP = _newGrp addWaypoint [_destPos, 100];
					_newWP setWaypointType "GUARD";
				} else {
					_newWP = _newGrp addWaypoint [_startPos, 0];
					waitUntil{sleep 0.5; if (_selVeh distance2D _startPos < 50 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
					if (!alive _leader || !canMove _selVeh) exitWith {};
					_selVeh deleteVehicleCrew driver _selVeh;
					deleteGroup _newGrp;
					deleteVehicle _selVeh;
				};
			};
		};
	} else {
		// Unit is a transport.
		_reinfGrp setBehaviour "CARELESS";
		_soldierArr = [selectRandom _manArray];
		
		for [{_i = 1}, {_i < (([_unitClass, true] call BIS_fnc_crewCount) - ([_unitClass, false] call BIS_fnc_crewCount))}, {_i = _i + 1}] do {
			_soldierArr pushBack (selectRandom _manArray);
		};

		_paraUnit = [[0,0,0], _side, _soldierArr] call BIS_fnc_spawnGroup;
		{
			_x assignAsCargo _grpVeh;
			[_x] orderGetIn TRUE;
			_x moveInCargo _grpVeh;
			_x allowFleeing 0;
		} forEach units _paraUnit;
		
		_landPos = [_targetPos, 300, random 360] call BIS_fnc_relPos;		
		_unloadWP = _reinfGrp addWaypoint [_landPos, 100];
		_unloadWP setWaypointStatements ["TRUE", "(vehicle this) land 'GET OUT'; {unassignVehicle _x; [_x] orderGetIn FALSE} forEach ((crew vehicle this) select {group _x != group this})"];
		_newWP = _reinfGrp addWaypoint [waypointPosition _unloadWP, 0];
		_newWP setWaypointStatements ["{group _x != group this && alive _x} count crew vehicle this == 0", ""];
		
		_weapCount = 0;
		{
			_weapCount = _weapCount + count ((vehicle leader _reinfGrp weaponsTurret _x) select { !(["CMFlareLauncher",_x] call BIS_fnc_inString) });			
		} forEach ([[-1]] + (allTurrets (vehicle leader _reinfGrp))); 
		
		// If has turrets hang around AO, otherwise despawn.
		if (_weapCount > 1) then {
			_newWP = _reinfGrp addWaypoint [_targetPos, 0];
			_newWP setWaypointType "SAD";
			_newWP setWaypointCompletionRadius 300;
			_newWP setWaypointBehaviour "AWARE";
			_newWP = _reinfGrp addWaypoint [_targetPos, 1];
			_newWP setWaypointType "LOITER";
			_newWP setWaypointCompletionRadius 500;
		} else {
			_newWP = _reinfGrp addWaypoint [_startingPos, 0];
			_null = [_reinfGrp, _startingPos] spawn {
				params ["_reinfGrp","_startingPos"];
				_heli = vehicle leader _reinfGrp;
				waitUntil{sleep 5; if ((leader _reinfGrp) distance2D _startingPos > 200 || !alive (leader _reinfGrp) || !canMove _heli) exitWith {true}; false; };
				waitUntil{sleep 0.5; if ((leader _reinfGrp) distance2D _startingPos < 200 || !alive (leader _reinfGrp) || !canMove _heli) exitWith {true}; false; };
				if (!alive (leader _reinfGrp) || !canMove _heli) exitWith {};
				{_heli deleteVehicleCrew _x} forEach crew _heli;
				deleteGroup _reinfGrp;
				deleteVehicle _heli;
			};
		};
		for [{_i = 0}, {_i < 3}, {_i = _i + 1}] do {
			_newWP = _paraUnit addWaypoint [_targetPos, 100];
			_newWP setWaypointType "SAD";
		};
		_newWP = _paraUnit addWaypoint [_targetPos, 100];
		_newWP setWaypointType "GUARD";
		_reinfGrp = _paraUnit;
	};
	
	_reinfGrp deleteGroupWhenEmpty true;
	{ _x addCuratorEditableObjects [(units _reinfGrp) + [_grpVeh], TRUE] } forEach allCurators;

	if (_sleep) then {
		sleep random 20;
	};
};

// PREPERATION
_safePositions = [];
_spawns = [];

missionNamespace setVariable [format["ZRF_%1Soldier", _side], _Soldier]; // Variable array for function reference.

// Create safe-zones around spawn.
{
	if (_x in allMapMarkers) then {		
		_mkr = createMarkerLocal [format ["safezone_%1", _forEachIndex + 1000], getMarkerPos _x];
		_mkr setMarkerShapeLocal "ELLIPSE";
		_mkr setMarkerSizeLocal [1000,1000];
		_mkr setMarkerAlphaLocal 0.25;
	};
} forEach ["respawn_west","respawn_east","respawn_guerrila","respawn_civilian"];

{	
	if (["safezone_", toLower _x] call BIS_fnc_inString) then { _safePositions pushBack _x; };
} forEach allMapMarkers;

// White list custom spawns.
{	
	if (["qrf_", toLower _x] call BIS_fnc_inString) then { _spawns pushBack getMarkerPos _x; };
} forEach allMapMarkers;

// Collect all roads 2km around the location that are not in a safe location.
for [{_i = 0}, {_i <= 360}, {_i = _i + 1}] do {
	_pos = [_location, _spawnDist, _i] call BIS_fnc_relPos;
	_roads = (_pos nearRoads 50) select {((boundingBoxReal _x) select 0) distance2D ((boundingBoxReal _x) select 1) >= 25};
	_exclude = false;
	
	{
		if (_pos inArea _x) exitWith {_exclude = true};
	} forEach _safePositions;
	
	if (count _roads > 0 && !_exclude) then {
		_road = _roads select 0;
		if ({_x distance2D _road < 100} count _spawns == 0) then {
			_connected = roadsConnectedTo _road;
			_nearestRoad = objNull;
			{if ((_x distance _location) < (_nearestRoad distance _location)) then {_nearestRoad = _x}} forEach _connected;
			_spawns pushBackUnique position _nearestRoad;
		};
	};
};

// DEBUG: Show Spawn Markers in local
{
	_mrkr = createMarkerLocal [format ["spawnMkr_%1", _forEachIndex], _x];
	(format ["spawnMkr_%1", _forEachIndex]) setMarkerTypeLocal "mil_dot";
	(format ["spawnMkr_%1", _forEachIndex]) setMarkerTextLocal str _forEachIndex;
} forEach _spawns;


// MAIN
// Spawn waves.
for [{_wave = 1}, {_wave < _waveMax}, {_wave = _wave + 1}] do {
	// Stop spawns if no-one is nearby.
	if (({ _location distance2D _x < (_spawnDist + 1000) } count (switchableUnits + playableUnits)) isEqualTo 0) exitWith {
		diag_log text format["[QRF] Aborting - No players within %1 meters!", _spawnDist + 1000];
	};
	
	switch (_wave) do {
		case 1: {
			[_location, _spawns, _side, selectRandom (_Light + _Truck)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Light + _Truck)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Light + _Air)] call ZRF_fnc_CreateReinforcements;
		};
		case 2: {
			[_location, _spawns, _side, selectRandom (_Light + _Truck)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Light + _Truck)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Air + _Medium)] call ZRF_fnc_CreateReinforcements;
		};
		case 3: {
			[_location, _spawns, _side, selectRandom (_Light + _Truck)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Truck + _Medium)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Medium + _CAS)] call ZRF_fnc_CreateReinforcements;
		};
		case 4: {
			[_location, _spawns, _side, selectRandom (_Light + _Truck)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Truck + _Medium)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Heavy + _Air)] call ZRF_fnc_CreateReinforcements;
		};
		default {
			[_location, _spawns, _side, selectRandom (_Light + _Truck)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Heavy + _Medium)] call ZRF_fnc_CreateReinforcements;
			[_location, _spawns, _side, selectRandom (_Heavy + _CAS)] call ZRF_fnc_CreateReinforcements;
		};
	};

	_tNextWave = time + _delay;	
	waitUntil {sleep 1; time > _tNextWave};
};