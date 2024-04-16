extends Node2D

## Referencia ao Label que mostra ao jogador a descrição das cartas
@onready var label_description: Label = $"../label_description"

# func ready
func _ready() -> void:
	Global.hand_controler = self
	for _a in range(Global.buy_letters_count):
		instance_letter()
	adjust_letters_pos()

## instancia uma nova carta e a configura
func instance_letter() -> void:
	if Global.letter_in_deck.size() > 0:
		var new_letter = Global.LETTER_SCENES[Global.buy_letter()].instantiate()

		add_child(new_letter)
		new_letter.connect("tree_exited", adjust_letters_pos)

## Ajusta a posição das cartas baseado na quantia de cartas na mão do jogador
func adjust_letters_pos() -> void:
	var ajuste = 0
	if get_child_count() % 2 == 1:
		ajuste = 35

	for letter in get_children():
		letter.global_position.x = (576 - (70 * int(float(get_child_count()) / 2))) + (letter.get_index() * 70) - ajuste
		letter.global_position.y = 528

## garante que apenas uma carta esteja selecionada por vez
## recebe um prametro do id da carta seleciona (-1 não selecionada nenhuma carta)
func unselect_letters(button_id:int=-1) -> void:
	for b in get_children():
		if b.get_index() != button_id:
			b.button_pressed = false

## Define e mostra a descrição no label de descrição
func set_description(description:String) -> void:
	label_description.text = description
	label_description.visible = true

## Esconde o label de descrição
func hide_description() -> void:
	label_description.visible = false
