extends Node2D
class_name GameControler

var can_buy := false

func _ready() -> void:
	Global.Controler = self
	await get_tree().create_timer(1).timeout
	can_buy = true
	turn_init()

func turn_end() -> void:
	if Global.letter_in_hand.size() > 7:
		Global.buy_letters_count = 2.0
		Global.mana_gain = 2.5
	if Global.buy_letters_count < Global.MAX_HAND_LETTER:
		Global.buy_letters_count += 0.5
	var lInRecharge := 0
	for n in Global.letter_in_recharge:
		lInRecharge += n.size()

	if lInRecharge > 0:
		_update_recharge_line()
		await Global.recharge_line.UpdateLetterPos
	turn_init()

func turn_init(limitMana:=true) -> void:
	Global.mana += int(Global.mana_gain)
	if Global.mana_gain < Global.MAX_MANA:
		Global.mana_gain += 0.5
	if (Global.mana > Global.MAX_MANA) and limitMana:
		Global.mana = Global.MAX_MANA
	Global.update_mana()
	Global.hide_next_letters()
	_buy_letters(int(Global.buy_letters_count))

func _buy_letters(quant:int, buy:=can_buy) -> void:
	can_buy = buy
	if can_buy:
		can_buy = false
		for a in range(quant):
			Global.hand_controler.instance_letter()
		Global.hand_controler.adjust_letters_pos()
		await Global.hand_controler.IsLetterOk
		can_buy = true

func _update_recharge_line() -> void:
	Global.recharge_line.update_recharge_line()
	Global.recharge_line.update_letters_pos()
