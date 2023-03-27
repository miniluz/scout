extends Node3D

var direction: Vector3
var speed: float
var velocity: Vector3
var angular_speed: float
var target: Node3D
const BRAKING_ACCEL = 3
const MAX_DISTANCE: float = 20 **2
const MAX_ANGLE = PI / 2
var total_rotated: float
enum State {
	WAIT,
	CHASE
}
var state: State = State.WAIT

# Called when the node enters the scene tree for the first time.
func initialize(spawn_position: Vector3, target_object: Node3D, initial_velocity: Vector3, max_speed: float, rotation_speed: float) -> void:
	position = spawn_position
	speed = max_speed
	velocity = initial_velocity
	angular_speed = rotation_speed
	target = target_object

	get_parent().get_node("Conductor").beat_signal.connect(start_chase)

func start_chase(_song) -> void:
	if state != State.CHASE:
		state = State.CHASE
		velocity = (target.position - position).normalized()

func _physics_process(delta: float):
	if state == State.WAIT:
		velocity = velocity.move_toward(Vector3.ZERO, BRAKING_ACCEL * delta)
		translate(velocity * delta)
	
	elif state == State.CHASE:
		if total_rotated <= MAX_ANGLE:
			var target_direction: Vector3 = (target.position - position).normalized()
			var angle_diff = velocity.angle_to(target_direction)

			if angle_diff <= angular_speed * delta: # If rotation just gets there
				velocity = target_direction
				total_rotated += angle_diff

			else:
				var axis: Vector3 = velocity.cross(target_direction).normalized()
				velocity = velocity.rotated(axis, angular_speed * delta)
				total_rotated += angular_speed * delta

		translate(velocity * speed * delta)
	
	if position.length_squared() > MAX_DISTANCE:
		queue_free()

func parry():
	print("Parried!")
	queue_free()

func hurt():
	queue_free()

func _on_hitbox_area_entered(area:Area3D):
	if area.is_in_group("PlayerHurtbox") and area.get_parent().vulnerable:
		hurt()

	if area.is_in_group("PlayerParry") and area.get_parent().parrying:
		parry()
