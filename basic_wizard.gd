extends CharacterBody2D

const MAX_HEALTH = 10
var health = MAX_HEALTH
var experience = 3
var is_slowed = false
var damage = 2

@onready var player = get_node("/root/Game/Player")

func _ready():
	$AnimatedSprite2D.play("walk")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	if is_slowed == true:
		velocity = direction * 25.0
	else:
		velocity = direction * 50.0
	move_and_slide()
	
func drop_chance():
	var new_coin = preload("res://experience_coin.tscn").instantiate()
	new_coin.global_position = self.global_position
	var coin_spawn = randf()
	#print(coin_spawn)
	if coin_spawn <= 0.12:
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
		drop_chance()
		queue_free()

func get_slowed():
	print("I'm slowed!")
	is_slowed = true

func _on_slow_timer_timeout() -> void:
	is_slowed = false

func shoot():
	const FIREBALL = preload("res://fireball.tscn")
	var new_fireball = FIREBALL.instantiate()
	new_fireball.global_position = %Marker2D.global_position
	new_fireball.global_rotation = %Marker2D.global_rotation
	new_fireball.collision_mask = 3
	new_fireball.damage += damage
	%Marker2D.add_child(new_fireball)

func _on_fireball_timer_timeout() -> void:
	shoot()
