extends TextureButton

class_name BaseLetter
## Nó que contem a animação da carta sendo "focada" pelo mouse
@onready var anim: AnimationPlayer = $anim
## Label que mostra o custo de mana da carta
@onready var label_mana_cost: Label = $label_mana_cost
## Label que mostra o tempo de recarga (em turnos)
@onready var label_recharge_time: Label = $label_recharge_time

@export var effect_node : Effects

## Dicionario que contem as informações basicas da carta
var letter_info : Dictionary
## String que contém o texto de descrição da carta
var description : String
## String que contem a referencia da carta
### Os valores são do tipo String  e se referen as chaves dos dicionarios 
### na região "Dicionarios de controle de atributos" do Script "Global"
var my_letter : String
## custo de mana da carta
var mana_cost := 0

## muda o modulate da carta, escurecendo ela quando selecionada
func _physics_process(_delta: float) -> void:
	if button_pressed:
		self_modulate = Color.DIM_GRAY
	else:
		self_modulate = Color.WHITE

func _input(event: InputEvent) -> void:
	## Mostra a decrição ao jogar apertar a letra "C" no teclado
	if event.is_action_pressed("descrition") and is_hovered():
		get_parent().set_description(description)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mb") and button_pressed:
		if Global.mana >= mana_cost:
			effect_node.effect()
		else:
			Global.hand_controler.unselect_letters()

## invoca uma unidade para o campo (se possivel) baseado na posição do mouse
## Quando a unidade é invocada, remove a carta da mão e a adiciona a linha de recarga
func summon_unit() -> void:
	var is_used := false
	for u in range(5):
		var unit_space = Global.tabuleiro.get_child(u + 5)
		if unit_space.is_hovered():
			if Global.units_space[unit_space.get_index()] == null:
				is_used = true
				unit_space.disabled = false
				unit_space.set_status(my_letter)
				Global.update_mana(mana_cost)

	if is_used:
		Global.letter_in_recharge[letter_info["recharge_time"]-1].append(my_letter)
		Global.letter_in_hand.erase(my_letter)
		Global.recharge_line.update_letters_in_recharge()
		queue_free()

## Inicia algumas atributos de controle de acordo com o tipo da carta
func init_letter(letter:String) -> void:
	texture_normal = Global.LETTER_SPRITES[letter]
	letter_info = Global.LETTER_ATRIBUTES[letter]
	set_description()
	set_values(letter)

## Defina a descrição, baseado nos valores de "letter_info"
func set_description() -> void:
	description = "Descrição: " + letter_info["description"] + \
		"\nCusto de mana: " + str(letter_info["mana_cost"]) + \
		"\nTempo de recarga: " + str(letter_info["recharge_time"]) + \
		"\nTipo de retorno de deck: " + str(letter_info["deck_return"]) + \
		"\nTipo de compra de deck: " + str(letter_info["deck_buy"]) + \
		"\nTipo de carta: " + letter_info["type"]

## Define alguns valores de acordo com o tipo da carta
func set_values(letter:String) -> void:
	mana_cost = letter_info["mana_cost"]
	label_mana_cost.text = str(mana_cost)
	label_recharge_time.text = str(letter_info["recharge_time"])
	my_letter = letter

#region responsaveis por aumentar e diminuir a carta quando passa o mouse
func _on_mouse_entered() -> void:
	z_index = 1
	anim.play("select")

func _on_mouse_exited() -> void:
	z_index = 0
	anim.play("unselect")
	get_parent().hide_description()

#endregion

## Deseleciona as demais cartas em mão
func _on_pressed() -> void:
	Global.hand_controler.unselect_letters(get_index())
