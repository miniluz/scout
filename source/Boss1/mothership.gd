class_name Enemy
extends Node3D

var current_pattern: Pattern
var Conductor: Conductor
var AttackTimer: Timer
var last_attack: int = -1

func _ready() -> void:
	Conductor = get_node("%Conductor")
	AttackTimer = $AttackTimer
	current_pattern = ALTERNATING_PATTERN()
	AttackTimer.one_shot = true
	AttackTimer.timeout.connect(at_subbeat)
	Conductor.beat_signal.connect(at_beat)
	set_subbeat(0)

func _physics_process(_delta) -> void:
	pass

func set_subbeat(subbeat: int) -> void:
	current_pattern.current = subbeat
	var current_attack: Attack = current_pattern.current_attack()
	current_attack.function.call(current_attack.parameters)
	last_attack = current_pattern.current
	AttackTimer.start(Conductor.sec_per_beat / current_pattern.subdivision)

func at_subbeat() -> void:
	var beat = current_pattern.current / current_pattern.subdivision
	var new_subbeat = current_pattern.current + 1
	if new_subbeat < (beat + 1) * current_pattern.subdivision:
		set_subbeat(new_subbeat)

func at_beat(_beat) -> void:
	print("Current subdiv: ", current_pattern.subdivision)
	var beat = current_pattern.current / current_pattern.subdivision
	var new_subbeat = (beat + 1) * current_pattern.subdivision
	if new_subbeat == current_pattern.length * current_pattern.subdivision:
		current_pattern = ALTERNATING_PATTERN()
		set_subbeat(0)
		print("CHANGEOVER")
	else:
		set_subbeat(new_subbeat)

@export var BasicBullet: PackedScene
func alternating(args: Array) -> void:
	const ammount: int = 20
	const angle: float = 2 * PI / ammount
	const speed: float = 5
	var offset: float = args[0]

	for i in range(ammount):
		var a: float = angle * (i + offset)
		var bullet = BasicBullet.instantiate()

		get_tree().current_scene.add_child.call_deferred(bullet)

		bullet.init(\
			position,\
			Vector3(cos(a), 0, sin(a)),\
			speed)

func ALTERNATING_PATTERN() -> Pattern:
	return Pattern.new(4, 1, [\
		Attack.new(alternating, [0.]),\
		Attack.new(alternating, [0.5]),\
		Attack.new(alternating, [0.]),\
		Attack.new(alternating, [0.5]),\
	])
