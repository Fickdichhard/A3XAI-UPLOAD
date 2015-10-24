A3XAI - Current Version: 0.2.1
=====

Introduction
---
A3XAI is a roaming/ambient AI spawning addon for ArmA 3 Exile mod (http://www.exilemod.com/).

Installing A3XAI
---
IMPORTANT: As of A3XAI 0.2.0, the installation steps have changed. If you already have A3XAI installed (before version 0.2.0), you must remove all A3XAI files from @ExileServer.

To install A3XAI:

1. Copy @A3XAI from "1. Installation Package" into your server's Arma 3 directory.
2. Modify your server's startup parameters to include @A3XAI. For example: -serverMod=@ExileServer;@A3XAI;

To configure A3XAI:

1. Unpack A3XAI_config.pbo (Recommended to use PBO Manager: http://www.armaholic.com/page.php?id=16369)
2. Edit config.cpp with a text editor (Recommended to use Notepad++: https://notepad-plus-plus.org/). Make your configuration changes.
3. Repack A3XAI_config.pbo

A3XAI Features
---

* Automatically-generated static AI spawns: A3XAI will spawn an AI group at various named locations on the map if players are nearby.
* Dynamic AI spawns: A3XAI will create ambient threat in the area for each player by periodically spawning AI to create unexpected ambush encounters. These AI may occasionally seek out and hunt a player.
* Random AI spawns: A3XAI will create spawns that are randomly placed around the map and are periodically relocated. These spawns are preferentially created in named locations, but may be also created anywhere in the world.
* Air and land vehicle AI patrols: AI patrol in vehicles around the map, looking for players to hunt down. Cars and trucks may roam the road, and helicopters (or jets) search the skies for players. Helicopters with available cargo space may also occasionally deploy an AI group by parachute.
* UAV and UGV patrols: Currently an experimental feature in testing. UAVs and UGVs patrol around the map, and if armed, will engage detected players. UAVs and UGVs may also call for AI reinforcements.
* Custom AI spawns: Users may also define custom infantry and vehicle AI spawns at specified locations.
* Exile-style Respect rewards: Players gain Respect rewards for killing AI, along with bonus points for "special" kills such as long-distance kills or kill-streaks.
* Adaptive classname system: A3XAI reads Exile's trader tables to find items that AI can use, such as weapons and equipment. Users may also choose to manually specify classnames to use instead.
* Error-checking ability: A3XAI checks config files for errors upon startup. If errors are found, A3XAI will use backup settings and continue operating as normal.
* Classname verification: A3XAI filters out invalid or banned classnames and prevents them from being used by AI.
* Universal map support: A3XAI supports any and every map for Arma 3 without changing any settings.
* Plug-and-play installation: Installing and upgrading A3XAI is a simple copy and paste job and does not require modifying any Exile files.
* Easy configuration: A single configuration file contains all settings for A3XAI. This config file is external to the A3XAI pbo, so configuration changes can be made without ever having to unpack or repack the pbo file.
* Headless Client support: Offload AI calculations from your dedicated server to a headless client to improve server performance. The A3XAI HC can be started/stopped/restarted any time without causing problems.

Support A3XAI
---
if you would like to support development of A3XAI, you can contribute to A3XAI with a donation by clicking on the Donate Icon below. Thank you for your support!

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=9PESMPV4SQFDJ)


This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
