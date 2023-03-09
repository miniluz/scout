extends Node3D

var target: Vector3
var speed: float = 1

# Called when the node enters the scene tree for the first time.
func initialize(spawn_position, target_position):
	position = spawn_position
	target = target_position

func _physics_process(delta):
	position = position.move_toward(target, speed * delta)
