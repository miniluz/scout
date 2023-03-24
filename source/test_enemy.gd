extends Node3D

@export var bullet_scene: PackedScene
@export var enable: bool


func _on_conductor_beat_signal(_song_position_in_beats) -> void:
	if not enable:
		return
	
	var bullet = bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.initialize(position, get_parent().get_node("Player"), Vector3(0,0,5), 10, 90 * PI / 180)
