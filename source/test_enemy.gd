extends Node3D

@export var bullet_scene: PackedScene
@export var enable: bool

const BULLET_AMMOUNT: int = 20

var offset: int = 0

func _on_conductor_beat_signal(_song_position_in_beats) -> void:
	if not enable:
		return
	
	offset = (offset + 1) % 2
	
	for i in range(BULLET_AMMOUNT):
		var bullet = bullet_scene.instantiate()

		var angle: float = TAU/BULLET_AMMOUNT * (i + offset/2.)

		bullet.initialize(position, Vector3(cos(angle), 0, sin(angle)))

		get_tree().current_scene.add_child(bullet)
