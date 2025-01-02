extends Node2D

# Constants
const MOB_SCENE := preload("res://mob.tscn")
const ANGRY_MOB_SCENE := preload("res://angry_mob.tscn")
const BASIC_WIZARD_SCENE := preload("res://basic_wizard.tscn")

# State
var round_counter := 1
var score_counter := 0

# Node References
@onready var path_follow: PathFollow2D = %PathFollow2D
@onready var mob_timer: Timer = %MobTimer
@onready var angry_mob_timer: Timer = %AngryMobTimer
@onready var basic_wizard_timer: Timer = %BasicWizardTimer
@onready var round_timer: Timer = %RoundTimer
@onready var round_timer_label: Label = %RoundTimerCountdown
@onready var round_label: Label = %RoundLabel
@onready var score_label: Label = %ScoreLabel
@onready var level_up_screen: CanvasLayer = %LevelUpScreen
@onready var round_over_screen: CanvasLayer = %RoundOver
@onready var round_over_label: Label = %RoundOverLabel
@onready var game_over_screen: CanvasLayer = %GameOver
@onready var pause_screen: CanvasLayer = %PauseScreen
@onready var player: Node = $Player

func _ready() -> void:
	_load_persistent_data()
	_update_round_display()
	_enable_new_enemies()

func _physics_process(_delta: float) -> void:
	_update_timer_display()
	_update_score_display()
	_handle_pause_input()

# Spawn Functions
func spawn_mob() -> void:
	print("Spawn mob")
	var new_mob = MOB_SCENE.instantiate()
	_spawn_at_random_position(new_mob)

func spawn_angry_mob() -> void:
	print("Spawn angry")
	var new_mob = ANGRY_MOB_SCENE.instantiate()
	_spawn_at_random_position(new_mob)
#
func spawn_basic_wizard() -> void:
	var new_mob = BASIC_WIZARD_SCENE.instantiate()
	_spawn_at_random_position(new_mob)
	
func _spawn_at_random_position(mob: Node) -> void:
	path_follow.progress_ratio = randf()
	mob.global_position = path_follow.global_position
	add_child(mob)

# Round Management
func advance_round() -> void:
	round_counter += 1
	_save_game_state()
	get_tree().reload_current_scene()

func _enable_new_enemies() -> void:
	if !mob_timer.autostart:
		mob_timer.start()
		
	if round_counter >= 2 && !angry_mob_timer.autostart:
		angry_mob_timer.start()
	
	if round_counter >= 3 && !basic_wizard_timer.autostart:
		basic_wizard_timer.start()

# UI Management
func show_level_up() -> void:
	get_tree().paused = true
	level_up_screen.visible = true

func complete_level_up() -> void:
	level_up_screen.visible = false
	get_tree().paused = false

func show_round_over() -> void:
	round_timer_label.visible = false
	round_over_screen.visible = true
	round_over_label.text = "Level Reached: " + str(player.level)
	get_tree().paused = true

func show_game_over() -> void:
	game_over_screen.visible = true
	get_tree().paused = true

# Pause Management
func toggle_pause() -> void:
	if get_tree().paused:
		resume_game()
	else:
		pause_game()

func pause_game() -> void:
	get_tree().paused = true
	pause_screen.visible = true

func resume_game() -> void:
	get_tree().paused = false
	pause_screen.visible = false

# Private Helper Functions
func _load_persistent_data() -> void:
	if GameState.persistent_score > 0:
		score_counter = GameState.persistent_score
		round_counter = GameState.persistent_rounds

func _update_round_display() -> void:
	round_label.text = "Round: " + str(round_counter)

func _update_timer_display() -> void:
	round_timer_label.text = str(int(round_timer.time_left))

func _update_score_display() -> void:
	score_label.text = "Score: " + str(score_counter)

func _handle_pause_input() -> void:
	if Input.is_action_pressed("ui_cancel"):
		toggle_pause()

func _save_game_state() -> void:
	GameState.persistent_score = score_counter
	GameState.persistent_rounds = round_counter

# Signal Callbacks
func _on_mob_timer_timeout() -> void:
	spawn_mob()

func _on_angry_mob_timer_timeout() -> void:
	spawn_angry_mob()

func _on_basic_wizard_timer_timeout() -> void:
	spawn_basic_wizard()

func _on_round_timer_timeout() -> void:
	show_round_over()

func _on_player_level_up() -> void:
	show_level_up()

func _on_player_health_depleted() -> void:
	show_game_over()

func _on_continue_button_pressed() -> void:
	round_timer_label.visible = true
	get_tree().paused = false
	round_over_screen.visible = false
	round_timer.start(15)
	advance_round()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	game_over_screen.visible = false
	GameState.reset_for_new_game()
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Level Up Button Handlers
func _on_crossbow_button_pressed() -> void:
	complete_level_up()

func _on_orb_button_pressed() -> void:
	complete_level_up()

func _on_speed_button_pressed() -> void:
	complete_level_up()

func _on_crossbow_alt_button_pressed() -> void:
	%CrossbowAltButton.visible = false
	complete_level_up()

func _on_orb_alt_button_pressed() -> void:
	complete_level_up()
