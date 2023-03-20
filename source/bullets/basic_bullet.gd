extends Node3D

var direction: Vector3
const SPEED: float = 5
const MAX_DISTANCE: float = 20 **2

# Called when the node enters the scene tree for the first time.
func initialize(spawn_position: Vector3, bullet_direction: Vector3) -> void:
	position = spawn_position
	direction = bullet_direction

func _physics_process(delta: float):
	translate(direction * SPEED * delta)
	
	if position.length_squared() > MAX_DISTANCE:
		queue_free()

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
