extends CharacterBody2D

var health = 5
var experience = 2

@onready var player = get_node("/root/Game/Player")

func _ready():
	$AnimatedSprite2D.play("walk")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 100.0
	move_and_slide()
	
func drop_chance():
	var new_coin = preload("res://experience_coin.tscn").instantiate()
	new_coin.global_position = self.global_position
	var coin_spawn = randf()
	print(coin_spawn)
	if coin_spawn <= 0.25:
		get_parent().add_child(new_coin)
	
func take_damage():
	health -= 1
	#%AnimatedSprite2D.play("hurt")
	#%AnimatedSprite2D.play("walk")
	
	if health == 0:
		player.experience += 1
		drop_chance()
		queue_free()
