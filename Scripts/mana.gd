extends TextureButton

@onready var label_mana: Label = $label_mana

func _ready() -> void:
	Global.mana_contain = self
	update_text()

## Ataliza o valor do label da mana
func update_text() -> void:
	label_mana.text = str(Global.mana)

# Passa o turno e compra novas cartas
func _on_pressed() -> void:
	Global.Controler.turn_end()
