extends Effects

@export_range(1, 10) var defence_gain := 1

func effect() -> void:
	for u in range(5, 10):
		var unit = (Global.tabuleiro as TabuleiroBase).get_child(u) as UnitBase

		if unit.is_summoned:
			unit.gain_defence(defence_gain)

	letter.used_letter()
