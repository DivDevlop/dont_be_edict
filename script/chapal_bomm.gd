extends RigidBody3D

@onready var timer: Timer = $Timer
@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D


func _ready() -> void:
	add_to_group("bomb")


func _on_timer_timeout() -> void:
	self.queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		timer.start()
		cpu_particles_3d.emitting = true
