extends Node2D

func _process(delta: float) -> void:
	%RoundTimerCountdown.text = str(%RoundTimer.wait_time)

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	if %Timer.wait_time > 0.3:
		%Timer.wait_time -= 0.2
		print(str(%Timer.wait_time))

func _on_timer_timeout() -> void:
	spawn_mob()

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true

func _on_round_timer_timeout() -> void:
	get_tree().paused = true
