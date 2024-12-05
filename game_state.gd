# Add a new autoload/singleton script called GameState.gd
extends Node

var persistent_score: int = 0
var persistent_rounds: int = 0
var persistent_upgrades: Dictionary = {
	"crossbow_level": 0,
	"crossbow_pierce": false,
	"crossbow_max_pierces": 0,
	"crossbow_can_slow": false,
	"crossbow_can_freeze": false,
	"orb_damage": 0,
	"player_speed": 300.0,
	"player_level": 0,
	"player_hp": 100,
	"player_max_health": 100,
	"player_exp": 0
}

func reset_for_new_game() -> void:
	persistent_score = 0
	persistent_rounds = 0
	persistent_upgrades = {
		"crossbow_level": 1,
		"crossbow_pierce": false,
		"crossbow_max_pierces": 0,
		"crossbow_can_slow": false,
		"crossbow_can_freeze": false,
		"orb_damage": 0,
		"player_speed": 300.0,
		"player_level": 0,
		"player_hp": 100,
		"player_max_health": 100,
		"player_exp": 0,
		
	}
