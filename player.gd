extends CharacterBody2D

signal health_depleted
signal level_up

var max_health = 100
@onready var current_health: int = max_health
var experience = 0
@export var level = 1

@export var speed = 300.0
# var screen_size

# Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	screen_size = get_viewport_rect().size

func check_experience() -> void:
	%ProgressBar2.value = experience % (level * 5)
	if experience >= level * 5:
		level += 1
		max_health += 5
		current_health = max_health
		experience = 0
		%ProgressBar.max_value = max_health
		%ProgressBar.value = current_health
		%ProgressBar2.max_value = level * 5
		%HPLabel.text = "HP: " + str(int(current_health))
		%XPLabel.text = "Level " + str(int(level))
		level_up.emit()
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%HPLabel.text = "HP: " + str(int(current_health))
	%XPLabel.text = "Level " + str(int(level))
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	
	else:
		$AnimatedSprite2D.play("idle")
		
	#Todo: Create a damage rate signal that enemies pass a damage value to the player
	const DAMAGE_RATE = 50.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		current_health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = current_health
		#%HPLabel.text = str(int(current_health))
		if current_health <= 0.0:
			health_depleted.emit()
	
	check_experience()

func _on_crossbow_button_pressed() -> void:
	crossbow_improve()

func crossbow_improve() -> void:
	if %Crossbow.pierce == false:
		%Crossbow.pierce = true
		%Crossbow.max_pierces = 1
	else:
		%Crossbow.max_pierces += 1

func _on_orb_button_pressed() -> void:
	orb_improve()

func orb_improve() -> void:
	%Orb.damage += 1
	#if %Orb.upgrade_level >= 4:
		#if %Timer.wait_time >= 0.6:
			#%Timer.wait_time -= 0.1
	#print(%Timer.wait_time)

func _on_speed_button_pressed() -> void:
	speed += 10.0
	#print(speed)
