extends Area2D

@onready var player = get_node("/root/Game/Player")

func _ready():
	$AnimatedSprite2D.play("idle")
	
func _on_body_entered(body: Node2D) -> void:
	player.experience += 1
	queue_free()
