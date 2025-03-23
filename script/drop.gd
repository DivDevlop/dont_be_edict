extends Node3D


@export var object_scene: PackedScene

func spawn_object():
	if object_scene:
		var obj = object_scene.instantiate()
		obj.transform.origin = self.position
		add_child(obj)




func _on_area_3d_area_entered(area: Area3D) -> void:
	spawn_object()
