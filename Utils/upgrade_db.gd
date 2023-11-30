extends Node



#const ICON_PATH = ""
const WEAPON_PATH = "res://Ground/"

const UPGRADES = {
	"spell_1_1": {
		"icon": WEAPON_PATH + "fireball.png",
		"displayname": "Fire Ball",
		"details": "A fire ball is thrown at a random enemy",
		"level": "Level: 1",
		"prerequesite": [],
		"type": "weapon"
	},
	"spell_1_2": {
		"icon": WEAPON_PATH + "fireball.png",
		"displayname": "Fire Ball",
		"details": "An addition fire ball is thrown at a random enemy",
		"level": "Level: 2",
		"prerequesite": ["spell_1_1"],
		"type": "weapon"
	},
	"spell_1_3": {
		"icon": WEAPON_PATH + "fireball.png",
		"displayname": "Fire Ball",
		"details": "Fire balls pass though enemies and more damage",
		"level": "Level: 3",
		"prerequesite": ["spell_1_2"],
		"type": "weapon"
	},
	"spell_1_4": {
		"icon": WEAPON_PATH + "fireball.png",
		"displayname": "Fire Ball",
		"details": "An addition fire ball is thrown",
		"level": "Level: 4",
		"prerequesite": ["spell_1_3"],
		"type": "weapon"
	},
	"leaf_spell_1": {
		"icon": WEAPON_PATH + "nature.png",
		"displayname": "Nature Force",
		"details": "A nature force is thrown at the same player direction",
		"level": "Level: 1",
		"prerequesite": [],
		"type": "weapon"
	},
	"leaf_spell_2": {
		"icon": WEAPON_PATH + "nature.png",
		"displayname": "Nature Force",
		"details": "An additional nature force",
		"level": "Level: 2",
		"prerequesite": ["leaf_spell_1"],
		"type": "weapon"
	},
	"leaf_spell_3": {
		"icon": WEAPON_PATH + "nature.png",
		"displayname": "Nature Force",
		"details": "An additional nature force",
		"level": "Level: 3",
		"prerequesite": ["leaf_spell_2"],
		"type": "weapon"
	},
	"leaf_spell_4": {
		"icon": WEAPON_PATH + "nature.png",
		"displayname": "Nature Force",
		"details": "Nature force cause more damage and +25% knockback",
		"level": "Level: 4",
		"prerequesite": ["leaf_spell_3"],
		"type": "weapon"
	},
	"spear_1": {
		"icon": WEAPON_PATH + "spear.png",
		"displayname": "Magical Spear",
		"details": "A magical spear go though straight line into enemies",
		"level": "Level: 1",
		"prerequesite": [],
		"type": "weapon"
	},
	"spear_2": {
		"icon": WEAPON_PATH + "spear.png",
		"displayname": "Magical Spear",
		"details": "A magical spear go though straight line into enemies 2 times",
		"level": "Level: 2",
		"prerequesite": ["spear_1"],
		"type": "weapon"
	},
	"spear_3": {
		"icon": WEAPON_PATH + "spear.png",
		"displayname": "Magical Spear",
		"details": "A magical spear go though straight line into enemies 3 times",
		"level": "Level: 3",
		"prerequesite": ["spear_2"],
		"type": "weapon"
	},
	"spear_4": {
		"icon": WEAPON_PATH + "spear.png",
		"displayname": "Magical Spear",
		"details": "The magical spear gains more damage",
		"level": "Level: 4",
		"prerequesite": ["spear_3"],
		"type": "weapon"
	},
	"bota_1": {
		"icon": WEAPON_PATH + "bota.png",
		"displayname": "Speed",
		"details": "Movement Speed increased",
		"level": "Level: 1",
		"prerequesite": [],
		"type": "upgrade"
	},
	"bota_2": {
		"icon": WEAPON_PATH + "bota.png",
		"displayname": "Speed",
		"details": "Movement Speed increased",
		"level": "Level: 2",
		"prerequesite": ["bota_1"],
		"type": "upgrade"
	},
	"bota_3": {
		"icon": WEAPON_PATH + "bota.png",
		"displayname": "Speed",
		"details": "Movement Speed increased",
		"level": "Level: 3",
		"prerequesite": ["bota_2"],
		"type": "upgrade"
	},
	"bota_4": {
		"icon": WEAPON_PATH + "bota.png",
		"displayname": "Speed",
		"details": "Movement Speed increased",
		"level": "Level: 4",
		"prerequesite": ["bota_3"],
		"type": "upgrade"
	},
	"ring_1": {
		"icon": WEAPON_PATH + "ring.png",
		"displayname": "Ring",
		"details": "Your spells spawn an additional attack",
		"level": "Level: 1",
		"prerequesite": [],
		"type": "upgrade"
	},
	"ring_2": {
		"icon": WEAPON_PATH + "ring.png",
		"displayname": "Ring",
		"details": "Your spells spawn an additional attack",
		"level": "Level: 2",
		"prerequesite": ["ring_1"],
		"type": "upgrade"
	},
	"food": {
		"icon": WEAPON_PATH + "food.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequesite": [],
		"type": "item"
	}
}
