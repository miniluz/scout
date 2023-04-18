class_name Enemy
extends Node3D

var current_pattern: Pattern
var Conductor: Conductor
var AttackTimer: Timer
var last_attack: int = -1
var Player: Node3D

@export var BasicBullet: PackedScene
func alternating(args: Array) -> void:
	const ammount: int = 20
	const angle: float = 2 * PI / ammount
	const speed: float = 8
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
	return Pattern.new(4, 4, [\
		Attack.new(alternating, [1.]),\
		null,
		null,
		Attack.new(alternating, [1.5]),\
		null,
		null,
		Attack.new(alternating, [2.]),\
		null,
		null,
		null,
		Attack.new(alternating, [0.]),\
		null,
		null,
		Attack.new(alternating, [0.5]),\
		null,
		null,
	])

@export var TracingBullet: PackedScene
func chasing(_args: Array):
	var bullet = TracingBullet.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.initialize(position, Player, Vector3(0,0,5), 10, 90 * PI / 180)

func CHASING_PATTERN() -> Pattern:
	return Pattern.new(4, 1, [\
	Attack.new(chasing, []),\
	Attack.new(chasing, []),\
	Attack.new(chasing, []),\
	Attack.new(chasing, []),\
	])

func next_pattern() -> Pattern:
	return CHASING_PATTERN()

func _ready() -> void:
	Conductor = get_node("%Conductor")
	Player = get_node("%Player")
	AttackTimer = $AttackTimer
	current_pattern = ALTERNATING_PATTERN()
	AttackTimer.one_shot = false
	AttackTimer.timeout.connect(at_subbeat)
	Conductor.beat_signal.connect(at_beat)

func _physics_process(_delta) -> void:
	pass

func set_subbeat(subbeat: int) -> void:
	current_pattern.current = subbeat
	var current_attack: Attack = current_pattern.current_attack()
	if current_attack != null:
		current_attack.function.call(current_attack.parameters)
	last_attack = current_pattern.current

func at_subbeat() -> void:
	var new_subbeat = current_pattern.current + 1
	if new_subbeat % current_pattern.subdivision != 0: # Don't advance beyond the current beat for syncying
		set_subbeat(new_subbeat)
	if (new_subbeat + 1) % current_pattern.subdivision == 0: # Don't advance beyond the current beat for syncying
		AttackTimer.stop()

func at_beat(_beat) -> void:
	var beat = floor(current_pattern.current / float(current_pattern.subdivision)) # Advance to the next beat
	var new_subbeat = (beat + 1) * current_pattern.subdivision
	if new_subbeat == current_pattern.length * current_pattern.subdivision:
		current_pattern = next_pattern()
		set_subbeat(0)
	else:
		set_subbeat(new_subbeat)
	AttackTimer.start(Conductor.sec_per_beat / current_pattern.subdivision)
