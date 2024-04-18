extends Node

@onready var unit: TextureButton = $".."

func effect(e:int, target:UnitBase) -> void:
	if target != null:
		match e:
			Global.DefenceEffects.SPIKE:
				target.defeding(null)
