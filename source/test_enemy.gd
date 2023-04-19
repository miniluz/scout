extends Node3D

@export var bullet_scene: PackedScene
@export var enable: bool

func _ready() -> void:
	get_node("%Conductor").beat_signal.connect(_on_conductor_beat_signal)

func _on_conductor_beat_signal(_song_position_in_beats) -> void:
	if not enable:
		return
	
	var bullet = bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.init(position, get_node("%Player").position, 0.5)

	queue_free()
