extends TextureButton

@onready var bg: ColorRect = $bg

func _ready() -> void:
	Global.deck_controler = self

func show_next_letters() -> void:
	if Global.letter_in_deck.size() >= 5:
		for a in range(5):
			_set_letter(a)
	else:
		for a in range(Global.letter_in_deck.size()):
			_set_letter(a)
		for a in range(Global.letter_in_deck.size(), 5):
			bg.get_child(a).hide()
	bg.show()

func _set_letter(n:int) -> void:
	bg.get_child(n).texture = Global.LETTER_SPRITES[Global.letter_in_deck[n]]
	bg.get_child(n).show()

func hide_next_letters() -> void:
	bg.hide()

func _on_pressed() -> void:
	if button_pressed:
		show_next_letters()
	else:
		hide_next_letters()
