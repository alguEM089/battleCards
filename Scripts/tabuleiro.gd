extends ColorRect

func _ready() -> void:
	Global.tabuleiro = self

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		var n = randf()
		if n > 0.25:
			get_child(randi_range(0,4)).set_status("soldier")
		elif n > 0.70:
			get_child(randi_range(0,4)).set_status("shilder")
		else:
			get_child(randi_range(0,4)).set_status("spikeBall")
