extends Area2D

var upgrade_level = 1
var damage = 0

func _physics_process(delta: float) -> void:
	pass

func shoot():
	const LIGHTNING_BOLT = preload("res://lightning_bolt.tscn")
	var new_lightning_bolt = LIGHTNING_BOLT.instantiate()
	new_lightning_bolt.global_position = %Orb.global_position
	new_lightning_bolt.Line2D.add_point(get_enemy().global_position)
	#new_lightning_bolt.global_rotation = %Orb.global_rotation
	new_lightning_bolt.damage += damage
	%Orb.add_child(new_lightning_bolt)

func _on_timer_timeout() -> void:
	shoot()
	#print("Fireball spawned")

func get_enemy():
	if %TargetArea.has_overlapping_bodies() == true:
		var enemies = %TargetArea.get_overlapping_bodies()
		var enemy_target = randi_range(0, enemies.size())
		return enemy_target
