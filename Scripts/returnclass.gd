extends Node
class_name ReturnDeckClass

func comun() -> int:
	return randi_range(Global.letter_in_deck.size() - 2, Global.letter_in_deck.size())

func botton() -> int:
	return Global.letter_in_deck.size()

func priority() -> int:
	if Global.letter_in_deck.size() > 5:
		return randi_range(Global.letter_in_deck.size() - 8, Global.letter_in_deck.size() - 5)
	else:
		return Global.letter_in_deck.size()
