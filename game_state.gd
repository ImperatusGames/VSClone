# Add a new autoload/singleton script called GameState.gd
extends Node



var persistent_score: int = 0
var persistent_rounds: int = 0

const DEFAULT_PLAYER_CONFIG := {
	"speed": 300.0,
	"max_health": 100,
	"max_exp": 5
}

const DEFAULT_WEAPON_CONFIG := {
	"crossbow": {
		"level": 1,
		"pierce": false,
		"max_pierces": 0,
		"can_slow": false,
		"can_freeze": false
	},
	"orb": {
		"damage": 0
	}
}

var player_stats: Dictionary = {
	"level": 1,
	"hp": DEFAULT_PLAYER_CONFIG.max_health,
	"max_health": DEFAULT_PLAYER_CONFIG.max_health,
	"max_exp": DEFAULT_PLAYER_CONFIG.max_exp,
	"speed": DEFAULT_PLAYER_CONFIG.speed,
	"exp": 0
}

var weapon_stats: Dictionary = DEFAULT_WEAPON_CONFIG.duplicate(true)

func reset_for_new_game() -> void:
	persistent_score = 0
	persistent_rounds = 1
	player_stats = {
		"level": 1,
		"hp": DEFAULT_PLAYER_CONFIG.max_health,
		"max_health": DEFAULT_PLAYER_CONFIG.max_health,
		"max_exp": DEFAULT_PLAYER_CONFIG.max_exp,
		"speed": DEFAULT_PLAYER_CONFIG.speed,
		"exp": 0
	}
	weapon_stats = DEFAULT_WEAPON_CONFIG.duplicate(true)

func save_player_stats(stats: Dictionary) -> void:
	player_stats = stats.duplicate()

func save_weapon_stats(stats: Dictionary) -> void:
	weapon_stats = stats.duplicate()
