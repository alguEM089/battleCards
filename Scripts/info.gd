extends Label

## mostra informações para o dev
func _physics_process(_delta: float) -> void:
	text =  str("\ncartas no deck: ", Global.letter_in_deck) + \
			str("\ncartas na mão: ", Global.letter_in_hand) + \
			str("\ncartas em recarga: ", Global.letter_in_recharge)
