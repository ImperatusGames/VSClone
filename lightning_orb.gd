extends Area2D

var upgrade_level = 1
var damage = 0

func _physics_process(delta: float) -> void:
#	_move_towards_target(delta)
	pass

func shoot():
#	_draw()
	pass

func _on_timer_timeout() -> void:
	shoot()
	#print("Fireball spawned")

func get_enemy():
	if %TargetArea.has_overlapping_bodies() == true:
		var enemies = %TargetArea.get_overlapping_bodies()
		var enemy_target = randi_range(0, enemies.size())
		return enemy_target

#func _draw():
	#var from = %Orb.global_position()
	#var to = Vector2(0, 0)
#
	#from = from.normalized() * 100
	#to = to.normalized() * 100
#
	## blue
	#draw_line(from, to , Color(0, 0, 1), 5)
	## white
	#draw_line(from, to, Color(1, 1, 1), 1)
	#
#func _move_towards_target(delta):
  ## _wr_target_obj is a weak reference to the object I'm trying to 
  ## move towards.
	#var target = get_enemy()
	#var _target_pos = target.get_global_position()
	#var pos = get_global_position()
	#var dist_to = get_global_position().distance_to(_target_pos)
	#var movement = _target_pos - pos
#
	#movement = movement.normalized()
	#movement = movement * delta
