extends Node3D

var roll_iframes = 10. / 30.
var parry_iframes = 10. / 30.
var parry_window = 0.08
var break_window = 0.16
var roll_cooldown = 0.3
var parry_cooldown = 0.3
var vulnerable = true
var in_cooldown = false
var parrying = false

func _roll_and_parry(event):
	if event.is_action("Parry"):
		var time_off = get_node("../Conductor").closest_beat()[1]
		if time_off <= parry_window:
			parrying = true
			print("Got it!")
		if time_off <= break_window \
		and $iFrames.time_left < parry_iframes: # Do not punish player if they're already in iframes
			print("Close enough!")
			$iFrames.wait_time = parry_iframes
			$iFrames.start()
		$Cooldown.wait_time = parry_cooldown
		$Cooldown.start()
		vulnerable = false
		in_cooldown = true

func _input(event):
	# Part 1. Movement

	
	# Part 2. Roll and parry
	if not in_cooldown:
		_roll_and_parry(event)



func _on_cooldown_timeout():
	in_cooldown = false

func _on_i_frames_timeout():
	vulnerable = true
	parrying = false
