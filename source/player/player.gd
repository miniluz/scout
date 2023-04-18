extends Node3D

class_name Player

var ParryHitbox: Area3D
var ParryVisualizer: MeshInstance3D
var Hurtbox: Area3D
var iFrames: Timer
var Cooldown: Timer
var Conductor: AudioStreamPlayer

func _ready() -> void:
	ParryHitbox = $ParryHitbox
	Hurtbox = $Hurtbox	
	iFrames = $iFrames
	Cooldown = $Cooldown
	ParryVisualizer = $ParryVisualizer

### ROLL AND PARRY

const roll_iframes: float = 1. / 30.
const parry_iframes: float = 10. / 30.
const parry_window: float = 0.08
const break_window: float = 0.16
const roll_cooldown: float = 20. / 30.
const parry_cooldown: float = 0.3
var vulnerable: bool = true
var parrying: bool = false
const roll_distance: float = 0.5

enum State {
	IDLE,
	PARRY,
	ROLL
}

var state: State = State.IDLE

func _roll_and_parry(event: InputEvent) -> void:
	### PARRY
	if event.is_action("Parry"):
		var time_off = get_node("../Conductor").closest_beat()[1]
		if time_off <= parry_window:
			set_parrying(true)
			print("Got it!")
		if time_off <= break_window:
			print("Close enough!")
			set_iframes(parry_iframes)
		state = State.PARRY
		Cooldown.wait_time = parry_cooldown
		Cooldown.start()
	
	### ROLL
	elif event.is_action("Roll"):
		if velocity.length() < 0.2 * MAX_SPEED:
			return
		translate(velocity * roll_distance)
		state = State.ROLL
		set_vulnerable(false)
		set_iframes(roll_iframes)
		Cooldown.wait_time = roll_cooldown
		Cooldown.start()

func set_iframes(iframes: float):
	if iFrames.time_left < iframes: # Don't shorten iFrames
		iFrames.wait_time = iframes
		iFrames.start()

func set_parrying(parry: bool) -> void:
	parrying = parry
	ParryVisualizer.visible = parry
	if parry:
		ParryHitbox.parry()

func set_vulnerable(vulnerability: bool) -> void:
	vulnerable = vulnerability

func _input(event: InputEvent) -> void:
	if state == State.IDLE:
		_roll_and_parry(event)

func _on_cooldown_timeout() -> void:
	state = State.IDLE

func _on_i_frames_timeout() -> void:
	set_vulnerable(true)
	set_parrying(false)

func _on_hurtbox_area_entered(area:Area3D) -> void:
	if area.is_in_group("Bullet"):
		if vulnerable and not parrying:
			print("Auch!")

### MOVEMENT

const MAX_SPEED: float = 12
const ACCELERATION: float = 32 * MAX_SPEED
const FRICTION: float = 32 * MAX_SPEED 
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

