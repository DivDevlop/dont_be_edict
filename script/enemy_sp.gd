extends Node3D

@export var enemy_scene: PackedScene
@export var time_between_waves: float = 5.0
@export var time_between_spawns: float = 1.0
@export var initial_enemies_per_wave: int = 3
@export var enemy_increment_per_wave: int = 2

var current_wave: int = 0
var spawn_points: Array

func _ready():
	spawn_points = get_children()  
	start_wave()

func start_wave():
	current_wave += 1
	var enemy_count = initial_enemies_per_wave + (enemy_increment_per_wave * (current_wave - 1))
	spawn_enemies(enemy_count)
	await get_tree().create_timer(time_between_waves).timeout
	start_wave()

func spawn_enemies(count: int):
	for i in count:
		spawn_enemy()
		await get_tree().create_timer(time_between_spawns).timeout

func spawn_enemy():
	if spawn_points.is_empty():
		return
	
	var spawn_location = spawn_points.pick_random()
	var enemy = enemy_scene.instantiate()
	enemy.global_transform.origin = spawn_location.global_transform.origin
	get_parent().call_deferred("add_child" ,enemy)
