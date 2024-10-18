extends Area2D

func _physics_process(delta: float) -> void:
	%Marker2D.rotation += 0.01

func shoot():
	const FIREBALL = preload("res://fireball.tscn")
	var new_fireball = FIREBALL.instantiate()
	new_fireball.global_position = %OrbSprite.global_position
	new_fireball.global_rotation = %OrbSprite.global_rotation
	%OrbSprite.add_child(new_fireball)

func _on_timer_timeout() -> void:
	shoot()
	print("Fireball spawned")
