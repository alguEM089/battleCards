extends Node

@onready var unit: TextureButton = $".."

func effect(e:int,target:UnitBase=null) -> void:
	if target != null:
		match e:
			Global.AttackEffects.DIE_ON_ATTACK:
				unit.die()
