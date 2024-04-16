extends Effects

@export var unit : String

func effect() -> void:
	get_parent().summon_unit(unit)
