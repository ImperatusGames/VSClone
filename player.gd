extends CharacterBody2D

# Signals
signal health_depleted
signal level_up

# Constants
const DAMAGE_RATE := 50.0

# Configuration
@export var speed := 300.0
@export var level := 1

# State
var max_health := 100
var experience := 0
var max_exp := 5
@onready var current_health: int = max_health

# Child node references
@onready var health_bar: ProgressBar = %ProgressBar
@onready var exp_bar: ProgressBar = %ProgressBar2
@onready var hp_label: Label = %HPLabel
@onready var xp_label: Label = %XPLabel
@onready var crossbow: Node = %Crossbow
@onready var orb: Node = %Orb

func _ready() -> void:
	_load_persistent_data()
	_update_ui()

func _process(delta: float) -> void:
	_handle_movement()
	_handle_animation()
	_handle_combat(delta)
	_check_experience()
	_persist_data()
	_update_ui()

# Private methods for organization
func _load_persistent_data() -> void:
	if GameState.player_stats.level > 1 or GameState.player_stats.exp != 0:
		# Apply crossbow upgrades
		crossbow.upgrade_level = GameState.weapon_stats.crossbow.level
		crossbow.pierce = GameState.weapon_stats.crossbow.pierce
		crossbow.max_pierces = GameState.weapon_stats.crossbow.max_pierces
		crossbow.can_slow = GameState.weapon_stats.crossbow.can_slow
		crossbow.can_freeze = GameState.weapon_stats.crossbow.can_freeze
		
		# Apply orb upgrades
		orb.damage = GameState.weapon_stats.orb.damage
		
		# Apply player stats
		speed = GameState.player_stats.speed
		level = GameState.player_stats.level
		max_health = GameState.player_stats.max_health
		max_exp = GameState.player_stats.max_exp
		current_health = GameState.player_stats.hp
		experience = GameState.player_stats.exp

func _update_ui() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	exp_bar.max_value = max_exp
	exp_bar.value = experience
	hp_label.text = "HP: " + str(int(current_health))
	xp_label.text = "Level " + str(int(level))

func _handle_movement() -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

func _handle_animation() -> void:
	$AnimatedSprite2D.play("walk" if velocity.length() > 0 else "idle")

func _handle_combat(delta: float) -> void:
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		current_health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		if current_health <= 0.0:
			health_depleted.emit()

func _check_experience() -> void:
	if experience >= max_exp:
		experience = experience - max_exp
		level += 1
		max_exp += 5
		max_health += 5
		current_health = max_health
		level_up.emit()

func _persist_data() -> void:
	var weapon_data = {
		"crossbow": {
			"level": crossbow.upgrade_level,
			"pierce": crossbow.pierce,
			"max_pierces": crossbow.max_pierces,
			"can_slow": crossbow.can_slow,
			"can_freeze": crossbow.can_freeze
		},
		"orb": {
			"damage": orb.damage
		}
	}
	
	var player_data = {
		"level": level,
		"hp": current_health,
		"max_health": max_health,
		"max_exp": max_exp,
		"speed": speed,
		"exp": experience
	}
	
	GameState.save_weapon_stats(weapon_data)
	GameState.save_player_stats(player_data)

# Upgrade methods
func crossbow_improve() -> void:
	crossbow.upgrade_level += 1
	if !crossbow.pierce:
		crossbow.pierce = true
		crossbow.max_pierces = 1
	else:
		crossbow.max_pierces += 1

func orb_improve() -> void:
	orb.damage += 1

func orb_spawn() -> void:
	const ORB = preload("res://orb.tscn")
	var new_orb = ORB.instantiate()
	new_orb.global_position = Vector2.ZERO
	new_orb.global_rotation = orb.global_rotation
	add_child(new_orb)

# Signal handlers
func _on_crossbow_button_pressed() -> void:
	crossbow_improve()

func _on_orb_button_pressed() -> void:
	orb_improve()

func _on_speed_button_pressed() -> void:
	speed += 10.0

func _on_orb_alt_button_pressed() -> void:
	orb_spawn()

func _on_crossbow_alt_button_pressed() -> void:
	if crossbow.upgrade_level <= 3:
		return
	elif !crossbow.can_slow:
		crossbow.can_slow = true
	elif crossbow.upgrade_level <= 7 && !crossbow.can_freeze:
		crossbow.can_freeze = true
