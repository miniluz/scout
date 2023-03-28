class_name Pattern

var length: int # in beats
var current: int = -1
var subdivision: int # of a beat
var attacks: Array # of attack, matching subdivision

func _init(pattern_length: int, subdiv: int, attack_array: Array):
	assert(len(attack_array) == pattern_length * subdiv,\
	"Not enough attacks: expected {expected}, got {got}"\
	.format({"expected": pattern_length * subdiv, "got": len(attack_array)}))

	for attack in attack_array:
		assert(attack is Attack || attack == null, "All attacks should be attacks")

	length = pattern_length
	subdivision = subdiv
	attacks = attack_array

func current_attack() -> Attack:
	return attacks[current]
