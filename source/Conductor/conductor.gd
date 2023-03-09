extends AudioStreamPlayer

@export
var bpm = 100
@export
var measures = 4

var sec_per_beat = 60.0 / bpm

var song_position = 0.0
var song_position_in_beats = 0
var last_reported_beat = 0
var measure = 0

signal beat_signal(song_position_in_beats)
signal measure_signal(measure)

func _ready():
	sec_per_beat = 60.0 / bpm

func _physics_process(_delta):
	if playing:
		song_position = get_playback_position()
		song_position += AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor( song_position/sec_per_beat))
		_report_beat()

func _report_beat():
	if last_reported_beat != song_position_in_beats:
		measure = measure % measures + 1
		emit_signal("beat_signal", song_position_in_beats)
		emit_signal("measure_signal", measure)
		last_reported_beat = song_position_in_beats

func start_playing():
	play()
	_report_beat()

func closest_beat():
	var closest = int(round(song_position / sec_per_beat))
	var time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)
