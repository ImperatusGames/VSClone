extends Node2D

var round_counter = 1
var score_counter = 0

func _physics_process(delta: float) -> void:
	update_timer_text()
	update_score()
	if Input.is_action_pressed("ui_cancel"):
		pause_game()

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	if %MobTimer.wait_time > 1.0:
		%MobTimer.wait_time -= 0.1
		#print(str(%Timer.wait_time))
		
func spawn_second_mob():
	var new_mob = preload("res://angry_mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	
func spawn_basic_wizard_mob():
	var new_mob = preload("res://basic_wizard.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _on_timer_timeout() -> void:
	spawn_mob()

func update_timer_text() -> void:
	%RoundTimerCountdown.text = str(int(%RoundTimer.time_left))
	
func _on_player_level_up() -> void:
	get_tree().paused = true
	%LevelUpScreen.visible = true
	
func _on_crossbow_button_pressed() -> void:
	level_up_complete()

func _on_orb_button_pressed() -> void:
	level_up_complete()

func _on_speed_button_pressed() -> void:
	level_up_complete()

func level_up_complete() -> void:
	%LevelUpScreen.visible = false
	get_tree().paused = false

#RoundOver
func _on_round_timer_timeout() -> void:
	%RoundTimerCountdown.visible = false
	%RoundOver.visible = true
	%RoundOverLabel.text = "Level Reached: " + str($Player.level)
	get_tree().paused = true

func _on_continue_button_pressed() -> void:
	%RoundTimerCountdown.visible = true
	get_tree().paused = false
	%RoundOver.visible = false
	%RoundTimer.start(15)
	round_tracker()
	%RoundLabel.text = "Round: " + str(round_counter)
	

#GameOver
func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	%GameOver.visible = false
	get_tree().reload_current_scene()
	
#Quit
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_orb_alt_button_pressed() -> void:
	level_up_complete()

func _on_crossbow_alt_button_pressed() -> void:
	%CrossbowAltButton.visible = false
	%LevelUpScreen.visible = false
	get_tree().paused = false

func _on_angry_mob_timer_timeout() -> void:
	spawn_second_mob()

func _on_basic_wizard_timer_timeout() -> void:
	spawn_basic_wizard_mob()

func round_tracker():
	round_counter += 1
	
	if round_counter >= 2 && %AngryMobTimer.autostart == false:
		%AngryMobTimer.start()
		
	if round_counter >= 3 && %BasicWizardTimer.autostart == false:
		%BasicWizardTimer.start()

func update_score():
	%ScoreLabel.text = "Score: " + str(score_counter)

func pause_game():
	get_tree().paused = true
	%PauseScreen.visible = true

func resume_game():
	get_tree().paused = false
	%PauseScreen.visible = false

func _on_resume_button_pressed() -> void:
	resume_game()
