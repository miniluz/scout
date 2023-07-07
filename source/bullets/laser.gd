extends Node3D

var direction: Vector3
var LaserMesh: CylinderMesh
const HEIGHT: float = 20
const INITIAL_RADIUS: float = 0.03
var final_radius: float

enum State {
  WAIT,
  FIRE
}
var state: State = State.WAIT

var Conductor: Conductor
var tween: Tween
var time

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
  
  look_at(target_position)

  Conductor = get_parent().get_node("Conductor")
  Conductor.beat_signal.connect(fire)

  time = Conductor.sec_per_beat
  
  tween = create_tween()
  tween.tween_property(LaserMesh, "top_radius", INITIAL_RADIUS/2., time)
  tween.parallel().tween_property(LaserMesh, "bottom_radius", INITIAL_RADIUS/2., time)

func _physics_process(_delta):
  if state == State.WAIT:
	look_at(get_parent().get_node("Player").position)

func fire(_song) -> void:
  if state != State.FIRE:
	state = State.FIRE
  Conductor.beat_signal.disconnect(fire)
  Conductor.beat_signal.connect(stop_firing)

  if tween:
	tween.kill()

  LaserMesh.top_radius = final_radius
  LaserMesh.bottom_radius = final_radius

  tween = create_tween()
  tween.tween_property(LaserMesh, "top_radius", 0., time)
  tween.parallel().tween_property(LaserMesh, "bottom_radius", 0., time)



func stop_firing(_song) -> void:
  queue_free()
