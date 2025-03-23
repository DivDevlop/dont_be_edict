extends Node3D




func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scen/world.tscn")
	$AudioStreamPlayer.play()


func _on_texture_button_2_pressed() -> void:
	pass # Replace with function body.
