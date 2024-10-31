extends Area2D

var damage = 1

func _physics_process(delta: float) -> void:
	if %Line2D.get_point_count() > 1:
		%CollisionShape2D.add

func _on_body_entered(body: Node2D) -> void:
	queue_free()
		
	if body.has_method("take_damage"):
		body.take_damage(damage)
