extends Node3D

const MAX_ROTATION: float = 15. / 180. * PI

func _process(_delta) -> void:
	var velocity: Vector3 = get_parent().velocity

	rotation = Vector3.ZERO

	if velocity == Vector3.ZERO:
		return

	### Get the axis to rotate around: perpendicular to velocity and Y axis.
	var rotation_axis: Vector3 = velocity.cross(Vector3(0,1,0)).normalized()
	var rotation_ammount: float = velocity.length() / get_parent().MAX_SPEED * MAX_ROTATION
	
	transform.basis = transform.basis.rotated(rotation_axis, -rotation_ammount)
