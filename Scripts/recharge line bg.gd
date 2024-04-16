extends ColorRect

class_name RechargeLine

func _ready() -> void:
	Global.recharge_line = self

## Mostra todas as cartas em recarga ao apertar o botão
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("show"):
		for c in get_children():
			c.show_letters()

## atualiza as cartas no jogo que estão na linha de recarga
func update_letters_in_recharge() -> void:
	for n in range(5):
		get_child(n).is_show_letters = false
		for l in get_child(n).get_children():
			l.queue_free()

	for space in range(5):
		for letter in Global.letter_in_recharge[space]:
			var new_sprite = Sprite2D.new()
			get_child(space).add_child(new_sprite)
			new_sprite.position.y = 400 - (100 * space)
			new_sprite.texture = Global.LETTER_SPRITES[letter]
			new_sprite.centered = false

## manipula os dicionrios para que as cartas recarreguem uma vez
func update_recharge_line() -> void:
	for space in range(5):
		for letter in Global.letter_in_recharge[space]:
			if space == 0:
				Global.letter_in_deck.insert(_return_leter_deck(letter),letter)
			else:
				Global.letter_in_recharge[space - 1].append(letter)

		Global.letter_in_recharge[space].clear()

func _return_leter_deck(l:String) -> int:
	var letter_return = Global.LETTER_ATRIBUTES[l]["deck_return"]
	
	match letter_return:
		"comum":
			return ReturnDeck.comun()
		"priority":
			return ReturnDeck.priority()
		"botton":
			return ReturnDeck.botton()
		_:
			return -1



