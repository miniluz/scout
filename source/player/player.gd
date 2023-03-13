extends Node3D

const roll_iframes = 10. / 30.
const parry_iframes = 10. / 30.
const parry_window = 0.08
const break_window = 0.16
const roll_cooldown = 0.3
const parry_cooldown = 0.3
var vulnerable = true
var in_cooldown = false
var parrying = false

var ParryHitbox: Area3D
var Hurtbox: Area3D
var iFrames: Timer
var Cooldown: Timer
var Conductor: AudioStreamPlayer

func _ready() -> void:
	ParryHitbox = $ParryHitbox
	Hurtbox = $Hurtbox	
	iFrames = $iFrames
	Cooldown = $Cooldown

### ROLL AND PARRY

func _roll_and_parry(event: InputEvent) -> void:
	if event.is_action("Parry"):
		var time_off = get_node("../Conductor").closest_beat()[1]
		if time_off <= parry_window:
			set_parrying(true)
			print("Got it!")
		if time_off <= break_window \
		and iFrames.time_left < parry_iframes: # Do not punish player if they're already in iframes
			print("Close enough!")
			iFrames.wait_time = parry_iframes
			iFrames.start()
		Cooldown.wait_time = parry_cooldown
		Cooldown.start()
		set_vulnerable(false)
		in_cooldown = true

func set_parrying(parry: bool) -> void:
	parrying = parry
	if parry:
		ParryHitbox.parry()

func set_vulnerable(vulnerability: bool) -> void:
	vulnerable = vulnerability

func _input(event: InputEvent) -> void:
	if not in_cooldown:
		_roll_and_parry(event)

### MOVEMENT

const MAX_SPEED: float = 10
const ACCELERATION: float = 160
const FRICTION: float = 160
var velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var input_vector: Vector3 = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector != Vector3.ZERO:
		velocity = velocity.move_toward(input_vector.limit_length(1) * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, FRICTION * delta)

	translate(velocity * delta)

func _on_cooldown_timeout() -> void:
	in_cooldown = false

func _on_i_frames_timeout() -> void:
	set_vulnerable(true)
	set_parrying(false)

func _on_hurtbox_area_entered(area:Area3D) -> void:
	if area.is_in_group("Bullet"):
		if vulnerable and not parrying:
			print("Auch!")
