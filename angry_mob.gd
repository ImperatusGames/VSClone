extends CharacterBody2D

const MAX_HEALTH = 5
var health = MAX_HEALTH
var experience = 2
var is_slowed = false
var is_frozen = false
var score_value = 2

@onready var player = get_node("/root/Game/Player")
@onready var game = get_node("/root/Game/")

func _ready():
	$AnimatedSprite2D.play("walk")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	if is_slowed == true:
		velocity = direction * 50.0
	else:
		velocity = direction * 100.0
	move_and_slide()
	
func drop_chance():
	var new_coin = preload("res://experience_coin.tscn").instantiate()
	new_coin.global_position = self.global_position
	var coin_spawn = randf()
	#print(coin_spawn)
	if coin_spawn <= 0.25:
		get_parent().add_child(new_coin)
	
func take_damage(damage):
	%HPBar.max_value = MAX_HEALTH
	if %HPBar.visible == false:
		%HPBar.visible = true
	
	health -= damage
	%HPBar.value = health
	#%AnimatedSprite2D.play("hurt")
	#%AnimatedSprite2D.play("walk")
	
	if health == 0:
		player.experience += 1
		game.score_counter += score_value
		drop_chance()
		queue_free()

func get_slowed():
	print("I'm slowed!")
	is_slowed = true
	
func get_frozen():
	print("I'm frozen!")
	is_frozen = true

func _on_slow_timer_timeout() -> void:
	is_slowed = false

func _on_frozen_timer_timeout() -> void:
	is_frozen = false
