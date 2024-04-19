extends Effects

@export_range(1,50) var damage := 1
@export_range(1,10) var ticks := 1

func effect() -> void:
	var unit = Global.tabuleiro.get_valid_unit()

	if (unit != null) and (unit.is_summoned):
		for t in range(ticks):
			unit.defeding(null)
		letter.used_letter()
