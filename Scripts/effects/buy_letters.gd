extends Effects

@export_range(1, 10) var quant = 1
@export_range(1, 10) var mana_gain = 1

func effect() -> void:
	Global.purchage_letters(quant, mana_gain)

	letter.used_letter()
