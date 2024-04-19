extends TextureButton
class_name UnitBase

@onready var effect_on_attack: Node = $effect_on_attack
@onready var effect_on_defence: Node = $effect_on_defence

@onready var life: ColorRect = $life

var is_attacking := false
var is_summoned := false

var clear_texture := preload("res://Assets/clear_texture.png")

var attack_power := 0
var attack_count := 0
var defence := 0

var attack_effect := -1
var defence_effect := -1

var max_defence := 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mb") and is_attacking:
		attacking()
		button_pressed = false
		is_attacking = false
		self_modulate = Color.WHITE

func set_status(type:String) -> void:
	is_summoned = true
	
	attack_power = Global.UNITS_ATRIBUTES[type]["power"]
	attack_count = Global.UNITS_ATRIBUTES[type]["attacks"]
	defence = Global.UNITS_ATRIBUTES[type]["defence"]
	max_defence = defence
	
	attack_effect = Global.UNITS_ATRIBUTES[type]["attack_effect"]
	defence_effect = Global.UNITS_ATRIBUTES[type]["defence_effect"]
	
	texture_normal = Global.UNITS_ATRIBUTES[type]["texture"]

	life.size.x = 32
	life.show()

func attacking() -> void:
	for u in range(5):
		var unite_space = Global.tabuleiro.get_child(u) as UnitBase
		if unite_space.is_hovered() and (unite_space.is_summoned):
			for atk in range(attack_count):
				unite_space.defeding(self)
			effect_on_attack.effect(attack_effect, unite_space)

func defeding(attacker:UnitBase) -> void:
	defence -= 1
	_update_life_bar()
	if attacker and (defence_effect != -1):
		effect_on_defence.effect(defence_effect, attacker)

	if defence <= 0:
		die()

func gain_defence(defence_gain:int) -> void:
	defence += defence_gain
	max_defence += defence_gain
	_update_life_bar()

func _update_life_bar() -> void:
	if max_defence == defence:
		life.size.x = 32
	else:
		@warning_ignore("integer_division")
		life.size.x = (32 / max_defence) * defence


func die() -> void:
	is_summoned = false
	disabled = true
	attack_power = 0
	attack_count = 0
	defence = 0
	set_texture_normal(clear_texture)
	life.hide()

func _on_pressed() -> void:
	is_attacking = button_pressed
	if button_pressed:
		self_modulate = Color.WEB_GRAY
	else:
		self_modulate = Color.WHITE
