extends Node3D

var target: Vector3
var speed: float = 1

# Called when the node enters the scene tree for the first time.
func initialize(spawn_position, target_position):
	position = spawn_position
	target = target_position

func _physics_process(delta: float):
	position = position.move_toward(target, speed * delta)

func parry():
	print("Parried!")
	queue_free()

func hurt():
	queue_free()

func _on_hitbox_area_entered(area:Area3D):
	if area.is_in_group("Hurtbox"):
		hurt()

	if area.is_in_group("ParryHitbox") and area.get_parent().parrying:
		parry()
