extends CharacterBody2D

signal health_depleted
signal level_up

var max_health = 100
var current_health = max_health
var experience = 0
@export var level = 1

@export var speed = 300.0
# var screen_size

# Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	screen_size = get_viewport_rect().size

func check_experience() -> void:
	if experience == level * 5:
		level_up.emit()
		level += 1
		max_health += 5
		current_health = max_health
		%ProgressBar.max_value = max_health
		%ProgressBar.value = current_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%HPLabel.text = str(int(current_health))
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	
	else:
		$AnimatedSprite2D.play("idle")
		
	const DAMAGE_RATE = 50.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		current_health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = current_health
		#%HPLabel.text = str(int(current_health))
		if current_health <= 0.0:
			health_depleted.emit()
	
	check_experience()

		
