extends Node3D




@export var object_scene: PackedScene
@export var pl: Node3D
var money:int
var bomb:int

func _ready() -> void:
	bomb = 2


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drop"):
		if bomb >= 1:
			$DROP.play()
			spawn_object()
			bomb -= 1

func spawn_object():
	if object_scene:
		var obj = object_scene.instantiate()
		obj.transform.origin = pl.global_position
		add_child(obj)


func _on_area_3d_area_entered(area: Area3D) -> void:
	bomb += 6
