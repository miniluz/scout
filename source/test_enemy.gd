extends Node3D

@export var bullet_scene: PackedScene

func _on_conductor_beat_signal(_song_position_in_beats):
	print("Spawning enemy!")
	var bullet = bullet_scene.instantiate()

	bullet.initialize(position, get_node("../Player").position)

	get_tree().current_scene.add_child(bullet)
