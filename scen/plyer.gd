extends CharacterBody3D

@export var speed := 5.0
@export var jump_force := 4.0
@export var sensitivity := 0.005

@onready var camera = $CameraPivot/SpringArm3D/Camera3D
@onready var spring_arm = $CameraPivot/SpringArm3D
@onready var anim = $ch/AnimationPlayer

var gravity = 9.8
var velocity_y = 0.0
@export var was_on_floor:bool
@export var is_jumping:bool




func _ready():
	Globl.money = 10
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		spring_arm.rotate_x(-event.relative.y * sensitivity)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if $helt.value >= 50:
		$Label.visible = true
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()




func _physics_process(delta):
	
	var direction = Vector3.ZERO
	var move_speed = speed




	if not is_jumping:
		if Input.is_action_pressed("up"):
			direction -= transform.basis.z
		if Input.is_action_pressed("down"):
			direction += transform.basis.z
		if Input.is_action_pressed("left"):
			direction -= transform.basis.x
		if Input.is_action_pressed("right"):
			direction += transform.basis.x




	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			anim.play("jump")
			is_jumping = true
			return
	if not is_jumping:
		velocity_y -= gravity * delta  



	# Apply movement
	direction = direction.normalized()
	velocity = direction * move_speed
	velocity.y = velocity_y
	move_and_slide()




	if  is_on_floor():
		if not is_jumping:
			if direction.length() > 0:
				anim.play("run")
			else:
				anim.play("idel") 






func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jump":
		velocity_y = jump_force
		is_jumping = false





func _on_area_3d_2_area_entered(area: Area3D) -> void:
	$helt.value += 1


func _on_area_3d_2_area_exited(area: Area3D) -> void:
	$helt.value += 1
