extends Node3D

var direction: Vector3
var LaserMesh: CylinderMesh
const HEIGHT: float = 20
const INITIAL_RADIUS: float = 0.03
var final_radius: float

func init(spawn_position: Vector3, target_position: Vector3, radius: float) -> void:
  position = spawn_position
  final_radius = radius

  var Cylinder: Node3D = $Cylinder
  LaserMesh = Cylinder.mesh
  LaserMesh.top_radius = INITIAL_RADIUS
  LaserMesh.bottom_radius = INITIAL_RADIUS
  LaserMesh.height = HEIGHT
  Cylinder.rotate_x(90. * PI / 180.)
  Cylinder.position += Vector3(0, 0, -HEIGHT/2) # Center it around our root.
  print("Cylinder rotated")
  
  look_at(target_position)
