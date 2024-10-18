extends Area2D

#@onready var player = get_node("/root/Game/Player")

var travelled_distance = 0
var pierce = false
var pierce_count = 0
var max_pierces = 0

func _physics_process(delta: float) -> void:
	const SPEED = 500
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	
	if travelled_distance > RANGE:
		queue_free()

#func _on_player_level_up():
	#if player.level == 3:
		#pierce = true
		#print("Arrows should pierce")
		#max_pierces += 1
	#if player.level >= 5 && player.level <= 10:
		#max_pierces += 1

func _on_body_entered(body: Node2D) -> void:
	if pierce == false:
		queue_free()
	else:
		if pierce_count == max_pierces:
			queue_free()
		else:
			pierce_count + 1
		
	if body.has_method("take_damage"):
		body.take_damage()
