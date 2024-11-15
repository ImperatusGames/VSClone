extends Area2D

var travelled_distance = 0
var pierce = false
var max_pierces = 0
var pierce_count = 0
var damage = 1
var can_slow = false
var can_freeze = false

func _physics_process(delta: float) -> void:
	const SPEED = 500
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if pierce == false:
		queue_free()
	else:
		if pierce_count == max_pierces:
			queue_free()
		else:
			pierce_count += 1
		
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	if can_slow == true:
		if body.has_method("get_slowed"):
			var slow_chance = randf()
			if slow_chance <= 0.1:
				body.get_slowed()
				
	if can_freeze == true:
		if body.has_method("get_frozen"):
			var freeze_chance = randf()
			if freeze_chance <= 0.05:
				body.get_frozen()
			
