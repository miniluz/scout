extends Area3D

func parry() -> void:
	for bulletArea in get_overlapping_areas():
		if bulletArea.is_in_group("Bullet"):
			bulletArea.get_parent().parry()
