extends Label

func _ready() -> void:
	Global.label_mana = self
	update_text()

## Ataliza o valor do label da mana
func update_text() -> void:
	text = str(Global.mana)

# Passa o turno e compra novas cartas
func _on_mana_pressed() -> void:
	for a in range(Global.buy_letters_count):
		Global.hand_controler.instance_letter()

	Global.recharge_line.update_recharge_line()
	Global.recharge_line.update_letters_in_recharge()

	Global.hand_controler.adjust_letters_pos()
