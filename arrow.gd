extends Area2D

var travelled_distance = 0
var pierce = false
var max_pierces = 0
var pierce_count = 0
var damage = 1

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
