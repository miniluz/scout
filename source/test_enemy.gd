extends Node3D

@export var bullet_scene: PackedScene
@export var enable: bool

func _on_conductor_beat_signal(_song_position_in_beats) -> void:
	if not enable:
		return
	
	print("Spawning enemy!")
	var bullet = bullet_scene.instantiate()

	bullet.initialize(position, get_node("../Player").position)

	get_tree().current_scene.add_child(bullet)
