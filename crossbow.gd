extends Area2D

var upgrade_level = 1
var pierce = false
var max_pierces = 0
var can_slow = false
var can_freeze = false

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	const ARROW = preload("res://arrow.tscn")
	var new_bullet = ARROW.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	new_bullet.pierce = pierce
	new_bullet.max_pierces = max_pierces
	new_bullet.can_slow = can_slow
	new_bullet.can_freeze = can_freeze
	%ShootingPoint.add_child(new_bullet)

func _on_timer_timeout() -> void:
	shoot()
