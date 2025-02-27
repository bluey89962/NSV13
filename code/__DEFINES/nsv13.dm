//Nsv13 - Some of our necessary defines. The rest are inline with upstream's files.

#define TRAIT_NODIGEST			"no_digest"
#define TRAIT_SEASICK			"seasick"
#define TRAIT_MARINE_METABOLISM "marine-metabolism"
#define TRAIT_BINARY_SPEAKER	"speaks_binary"
#define TRAIT_MUNITIONS_METABOLISM    "munitions-metabolism" //NSV13
#define TRAIT_MUTATEIMMUNE             "mutate_immune" //NSV13 - IPCs do not get human mutations
#define TRAIT_IPCRADBRAINDAMAGE        "rad_brain_damage" //NSV13 - IPCs take brain damage when exposed to radiation

#define COMSIG_AI_UPDATE_LAWS 	"ai_law_update"

//Lazy cables
#define CABLE_LAYER_1 "l1"
#define CABLE_LAYER_2 "l2"
#define CABLE_LAYER_3 "l3"

#define WRAP_AROUND_VALUE(value, min, max) ( min + ((value - min) % (max - min)) )
#define COMSIG_ALERT_LEVEL_CHANGE "alert_level_changed" //For general quarters

#define COLOR_PUCE "#CC8899"

#define CONQUEST_ROLE_ADMIRAL "Admiral"
#define CONQUEST_ROLE_CAPTAIN "Captain"
#define CONQUEST_ROLE_BRIDGE "Bridge Staff"
#define CONQUEST_ROLE_REQUISITIONS "Requisitions"
#define CONQUEST_ROLE_TECHNICIAN "Technician"
#define CONQUEST_ROLE_CAG "CAG"
#define CONQUEST_ROLE_PILOT "Pilot"
#define CONQUEST_ROLE_SERGEANT "Sergeant"
#define CONQUEST_ROLE_CLOWN "Clown"
#define CONQUEST_ROLE_LINECOOK "Line Cook"
#define CONQUEST_ROLE_GRUNT "Autofill"

GLOBAL_DATUM_INIT(conquest_role_handler, /datum/conquest_role_handler, new)

#define COMSIG_ATOM_DAMAGE_ACT "comsig_atom_damage_act" //Used when an atom takes damage.

#define PASSDOOR (1<<7) //Can you pass doors?

//Math. Lame.
#define KPA_TO_PSI(A) (A/6.895)
#define PSI_TO_KPA(A) (A*6.895)
#define KELVIN_TO_CELSIUS(A) (A-273.15)
#define CELSIUS_TO_KELVIN(A) (A+273.15)
#define MEGAWATTS /1e+6

#define HARDPOINT_SLOT_PRIMARY "Primary"
#define HARDPOINT_SLOT_SECONDARY "Secondary"
#define HARDPOINT_SLOT_UTILITY "Utility"
#define HARDPOINT_SLOT_ARMOUR "Armour"
#define HARDPOINT_SLOT_DOCKING "Docking Module"
#define HARDPOINT_SLOT_CANOPY "Canopy"
#define HARDPOINT_SLOT_FUEL "Fuel Tank"
#define HARDPOINT_SLOT_ENGINE "Engine"
#define HARDPOINT_SLOT_RADAR "Radar"
#define HARDPOINT_SLOT_OXYGENATOR "Atmospheric Regulator"
#define HARDPOINT_SLOT_BATTERY "Battery"
#define HARDPOINT_SLOT_APU "APU"
#define HARDPOINT_SLOT_FTL "FTL"
#define HARDPOINT_SLOT_COUNTERMEASURE "Countermeasure"
#define HARDPOINT_SLOT_UTILITY_PRIMARY "Primary Utility"
#define HARDPOINT_SLOT_UTILITY_SECONDARY "Secondary Utility"

#define ALL_HARDPOINT_SLOTS list(HARDPOINT_SLOT_PRIMARY, HARDPOINT_SLOT_SECONDARY,HARDPOINT_SLOT_UTILITY, HARDPOINT_SLOT_ARMOUR, HARDPOINT_SLOT_FUEL, HARDPOINT_SLOT_ENGINE, HARDPOINT_SLOT_RADAR, HARDPOINT_SLOT_CANOPY, HARDPOINT_SLOT_OXYGENATOR,HARDPOINT_SLOT_DOCKING, HARDPOINT_SLOT_BATTERY, HARDPOINT_SLOT_APU, HARDPOINT_SLOT_FTL, HARDPOINT_SLOT_COUNTERMEASURE)
#define HARDPOINT_SLOTS_STANDARD list(HARDPOINT_SLOT_PRIMARY, HARDPOINT_SLOT_SECONDARY, HARDPOINT_SLOT_ARMOUR, HARDPOINT_SLOT_FUEL, HARDPOINT_SLOT_ENGINE, HARDPOINT_SLOT_RADAR,HARDPOINT_SLOT_CANOPY, HARDPOINT_SLOT_OXYGENATOR,HARDPOINT_SLOT_DOCKING, HARDPOINT_SLOT_BATTERY, HARDPOINT_SLOT_APU, HARDPOINT_SLOT_FTL, HARDPOINT_SLOT_COUNTERMEASURE)
#define HARDPOINT_SLOTS_UTILITY list(HARDPOINT_SLOT_UTILITY_PRIMARY,HARDPOINT_SLOT_UTILITY_SECONDARY, HARDPOINT_SLOT_ARMOUR, HARDPOINT_SLOT_FUEL, HARDPOINT_SLOT_ENGINE, HARDPOINT_SLOT_RADAR,HARDPOINT_SLOT_CANOPY, HARDPOINT_SLOT_OXYGENATOR,HARDPOINT_SLOT_DOCKING, HARDPOINT_SLOT_BATTERY, HARDPOINT_SLOT_APU, HARDPOINT_SLOT_FTL, HARDPOINT_SLOT_COUNTERMEASURE)

#define LOADOUT_DEFAULT_FIGHTER /datum/component/ship_loadout
#define LOADOUT_UTILITY_ONLY /datum/component/ship_loadout/utility

#define ENGINE_RPM_SPUN 8000

#define COMSIG_SHIP_BOARDED "ship_boarded"
#define COMSIG_GLOB_CHECK_INTERDICT "check_interdict"							//from interdiction component
#define BEING_INTERDICTED (1<<0)											//returned on successful interdict

//Gaming
#define shares_overmap(A, B) (A.get_overmap() == B.get_overmap())
#define SHARES_OVERMAP_ALLIED(A,B) (A.get_overmap()?.faction == B.get_overmap()?.faction)

#define YEAR_OFFSET 241

//AI flags
//Bitfields for AI behavior, because bitfields save us processing when compared with lists.
#define AI_FLAG_SUPPLY (1<<0)
#define AI_FLAG_BATTLESHIP (1<<1)
#define AI_FLAG_DESTROYER (1<<2)
#define AI_FLAG_ANTI_FIGHTER (1<<3)
#define AI_FLAG_BOARDER (1<<4) //Ships that like to board you.
#define AI_FLAG_SWARMER (1<<5) //Ships that love to act in swarms. Aka, Fighters.
#define AI_FLAG_ELITE (1<<6)	 //These ships are more /fun/ than others even with the same equipment.
#define AI_FLAG_STATIONARY (1<<7) //Overrides all other flags. Object will attempt to stay in place, restoring its angle if possible (and, obviously, shooting things)

//KNPC flags
#define KNPC_IS_MARTIAL_ARTIST (1<<0)	//Does the KNPC combo you right into the next round?
#define KNPC_IS_DODGER (1<<1)				//Does the KNPC become like the wind in CQC?
#define KNPC_IS_MERCIFUL (1<<2)			//Does the KNPC consider mobs in crit to be valid?
#define KNPC_IS_AREA_SPECIFIC (1<<3)		//Does the KNPC scream out the area when calling for backup?
#define KNPC_IS_DOOR_BASHER (1<<4)		//Does the KNPC kick the door off its hinges if it doesn't have a valid ID?
#define KNPC_IS_DOOR_HACKER (1<<5)		//Does the KNPC hack the door open if it doesn't have a valid ID?

//Starsystem Traits
#define STARSYSTEM_NO_ANOMALIES (1<<0)	//Prevents Anomalies Spawning
#define STARSYSTEM_NO_ASTEROIDS (1<<1)	//Prevents Asteroids Spawning
#define STARSYSTEM_NO_WORMHOLE (1<<2)	//Prevents Incoming Wormholes

//Overmap deletion behavior - Occupants are defined as non-simple mobs.
#define DAMAGE_ALWAYS_DELETES 		0 // Not a real bitflag, just here for readability. If no damage flags are set, damage will delete the overmap immediately regardless of anyone in it
#define DAMAGE_STARTS_COUNTDOWN		(1<<0) // When the overmap takes enough damage to be destroyed, begin a countdown after which it will be deleted
#define DAMAGE_DELETES_UNOCCUPIED	(1<<1) // When the overmap takes enough damage to be destroyed, if there are no occupants, delete it immediately. Modifies DAMAGE_STARTS_COUNTDOWN
#define NEVER_DELETE_OCCUPIED		(1<<2) // Even if the overmap takes enough damage to be destroyed, never delete it if it's occupied. I don't know when we'd use this it just seems useful
#define DELETE_UNOCCUPIED_ON_DEPARTURE 	(1<<3) // When a fighter/dropship leaves the map level for the overmap level, look for remaining occupants. If none exist, delete
#define FIGHTERS_ARE_OCCUPANTS		(1<<4) // Docked overmaps count as occupants when deciding whether to delete something
//NSV13 change end
