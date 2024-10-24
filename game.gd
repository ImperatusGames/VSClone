extends Node2D

func _physics_process(delta: float) -> void:
	update_timer_text()

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	if %Timer.wait_time > 1.0:
		%Timer.wait_time -= 0.1
		#print(str(%Timer.wait_time))
		
func spawn_second_mob():
	var new_mob = preload("res://angry_mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _on_timer_timeout() -> void:
	spawn_mob()
	spawn_second_mob()

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true

func _on_round_timer_timeout() -> void:
	get_tree().paused = true

func update_timer_text() -> void:
	%RoundTimerCountdown.text = str(int(%RoundTimer.time_left))
	
func _on_player_level_up() -> void:
	get_tree().paused = true
	%LevelUpScreen.visible = true
	
func _on_crossbow_button_pressed() -> void:
	%LevelUpScreen.visible = false
	get_tree().paused = false
