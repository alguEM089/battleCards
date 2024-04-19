extends Effects

@export_range(1, 10) var defence_gain := 1

func effect() -> void:
	var unit = Global.tabuleiro.get_valid_unit(true) as UnitBase

	if unit.is_summoned:
		unit.gain_defence(defence_gain)
		letter.used_letter()
