extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0

func _process(_delta):
	self.modulate.a = $FlashTimer.time_left / $FlashTimer.wait_time

func _on_conductor_beat_signal(_song_position_in_beats):
	$FlashTimer.start()
