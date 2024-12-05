extends CharacterBody2D

signal health_depleted
signal level_up

var max_health = 100
@onready var current_health: int = max_health
var experience = 0
@export var level = 1

@export var speed = 300.0
# var screen_size

func _ready() -> void:
	# Apply persistent upgrades if they exist
	print("persist 0")
	if GameState.persistent_upgrades["crossbow_level"] > 0:
		print("persist")
		%Crossbow.upgrade_level = GameState.persistent_upgrades["crossbow_level"]
		%Crossbow.pierce = GameState.persistent_upgrades["crossbow_pierce"]
		%Crossbow.max_pierces = GameState.persistent_upgrades["crossbow_max_pierces"]
		%Crossbow.can_slow = GameState.persistent_upgrades["crossbow_can_slow"]
		%Crossbow.can_freeze = GameState.persistent_upgrades["crossbow_can_freeze"]
		
		%Orb.damage = GameState.persistent_upgrades["orb_damage"]
		
		speed = GameState.persistent_upgrades["player_speed"]
		level = GameState.persistent_upgrades["player_level"]
		max_health = GameState.persistent_upgrades["player_max_health"]
		current_health = GameState.persistent_upgrades["player_hp"]
		experience = GameState.persistent_upgrades["player_exp"]
		

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
	persistData()
	check_experience()

func persistData() -> void:	
	# Save crossbow upgrades
	GameState.persistent_upgrades["crossbow_level"] = %Crossbow.upgrade_level
	GameState.persistent_upgrades["crossbow_pierce"] = %Crossbow.pierce
	GameState.persistent_upgrades["crossbow_max_pierces"] = %Crossbow.max_pierces
	GameState.persistent_upgrades["crossbow_can_slow"] = %Crossbow.can_slow
	GameState.persistent_upgrades["crossbow_can_freeze"] = %Crossbow.can_freeze
	# Save orb upgrades
	GameState.persistent_upgrades["orb_damage"] = %Orb.damage
	
	# Save player speed
	GameState.persistent_upgrades["player_speed"] = speed
	GameState.persistent_upgrades["player_level"] = level 
	GameState.persistent_upgrades["player_max_health"] = max_health
	GameState.persistent_upgrades["player_hp"] = current_health 
	GameState.persistent_upgrades["player_exp"] = experience

func _on_crossbow_button_pressed() -> void:
	crossbow_improve()

func crossbow_improve() -> void:
	%Crossbow.upgrade_level += 1
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
	
func orb_spawn() -> void:
	const ORB = preload("res://orb.tscn")
	var new_orb = ORB.instantiate()
	new_orb.global_position = Vector2.ZERO
	new_orb.global_rotation = %Orb.global_rotation
	self.add_child(new_orb)

func _on_speed_button_pressed() -> void:
	speed += 10.0
	#print(speed)

func _on_orb_alt_button_pressed() -> void:
	orb_spawn()

func _on_crossbow_alt_button_pressed() -> void:
	if %Crossbow.upgrade_level <= 3:
		pass
	elif %Crossbow.can_slow == false:
		%Crossbow.can_slow = true
	elif %Crossbow.upgrade_level <= 7 && %Crossbow.can_freeze == false:
		%Crossbow.can_freeze = true
	else:
		pass
