extends Area2D

var upgrade_level = 1
var damage = 0

func _physics_process(delta: float) -> void:
	%Marker2D.rotation += (1 * delta)

func shoot():
	const FIREBALL = preload("res://fireball.tscn")
	var new_fireball = FIREBALL.instantiate()
	new_fireball.global_position = %OrbSprite.global_position
	new_fireball.global_rotation = %OrbSprite.global_rotation
	new_fireball.collision_mask = 1
	new_fireball.collision_mask = 2
	new_fireball.damage += damage
	%OrbSprite.add_child(new_fireball)

func _on_timer_timeout() -> void:
	shoot()
	#print("Fireball spawned")
