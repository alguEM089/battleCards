extends ColorRect
class_name TabuleiroBase

func _ready() -> void:
	Global.tabuleiro = self

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		var n = randf()
		if n < 0.25:
			get_child(randi_range(0,4)).set_status("soldier")
		elif n < 0.7:
			get_child(randi_range(0,4)).set_status("shilder")
		else:
			get_child(randi_range(0,4)).set_status("spikeBall")

func get_valid_unit(player_unit:=false) -> UnitBase:
	var adjust_range = 0
	
	if player_unit:
		adjust_range = 5
	
	for u in range(0 + adjust_range, 5 + adjust_range):
		var unit = get_child(u) as UnitBase
		if unit.is_hovered():
			return unit
	
	return null
