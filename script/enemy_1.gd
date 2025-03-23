extends CharacterBody3D

var gravity = 9.8
var velocity_y = 0.0  # Separate Y velocity for gravity

@onready var player = $"../CharacterBody3D"
@onready var agent = $NavigationAgent3D
@onready var timer: Timer = $Timer

var speed = 3.0
var random_offset = Vector3.ZERO

@export var dead = false
@export var object_scene: PackedScene

func _ready():
	agent.path_desired_distance = 0.2
	agent.target_desired_distance = 0.0
	random_offset = Vector3(randf_range(-2, 2), 0, randf_range(-2, 2))

func _physics_process(delta):
	if dead:
		return

	# Apply gravity
	if not is_on_floor():
		velocity_y -= gravity * delta
	else:
		velocity_y = 0  # Reset Y velocity when on ground

	if player:
		var target_position = player.global_position + random_offset  # Offset target
		agent.set_target_position(target_position)

	move_along_path(delta)
	look_at_player()

	# Apply gravity to velocity
	velocity.y = velocity_y
	move_and_slide()

	if $RayCast3D.is_colliding():
		if not player:
			velocity_y += 1
			position.x += 1
			position.z += 1





func move_along_path(delta):
	if agent.is_navigation_finished():
		return

	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	
	# Preserve gravity while moving
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func look_at_player():
	if player:
		var look_pos = player.global_position
		look_pos.y = global_position.y
		look_at(look_pos, Vector3.UP)

func _on_timer_timeout() -> void:
	queue_free()
	spawn_object()

func _on_area_3d_area_entered(area: Area3D) -> void:
	print("enter")
	if area.is_in_group("bomb"):
		$AudioStreamPlayer.play()
		print("bomb")
		timer.start()
		$ded.visible = true
		dead = true

func spawn_object():
	if object_scene:
		var obj = object_scene.instantiate()
		obj.transform.origin = global_transform.origin  # Fix spawn position
		get_parent().add_child(obj)  # Spawn in parent scene
