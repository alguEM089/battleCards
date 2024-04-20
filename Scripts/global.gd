extends Node

enum AttackEffects {DIE_ON_ATTACK}
enum DefenceEffects {SPIKE}

#region Referencia de nós
## O controlador geral do jogo
var Controler : GameControler
## O tabuleiro onde são invocada as unidades
var tabuleiro : TabuleiroBase
## Label que mostra a quantia de mana atual
var mana_contain : TextureButton
## Linha de racarga que mostra o tempo (em rodadas) para as cartas usadas voltarem para mesa
var recharge_line : RechargeLine
## Nó que controla as cartas que estão na mão do jogador
var hand_controler : HandControler
## Controlador da textura do deck
var deck_controler : TextureButton
#endregion

#region Dicionarios de controle de atributos
## Dicionário que contem as informações gerais das cartas
const LETTER_ATRIBUTES = {
	"soldier" : {
		"description" : "Invoca uma unidade de 1 ataque, com 3 de dano e 1 defesa.",
		"mana_cost" : 1, "recharge_time" : 1, "deck_return" : "comum", 
		"deck_buy" : 0, "type" : "Unidade"
	},
	"shilder" : {
		"description" : "Invoca uma unidade de 1 ataque, com 1 de dano e 3 defesa.",
		"mana_cost" : 1, "recharge_time" : 1, "deck_return" : "comum",
		"deck_buy" : 0, "type" : "Unidade"
	},
	"spikeBall" : {
		"description" : "Invoca uma unidade que causa 1 ataque a quem o ataca. Não pode atacar.",
		"mana_cost" : 1, "recharge_time" : 2, "deck_return" : "comum",
		"deck_buy" : 0, "type" : "Unidade"
	},
	"undeadSoldier" : {
		"description" : "Invoca uma unidade de 1 ataque, com 5 de dano e 2 defesa. Se destroi ao atacar.",
		"mana_cost" : 1, "recharge_time" : 2, "deck_return" : "priority",
		"deck_buy" : 0, "type" : "Unidade"
	},
	"fireBall" : {
		"description" : "Lança uma bola de fogo de um ataque e 2 de dano",
		"mana_cost" : 1, "recharge_time" : 1, "deck_return" : "comum",
		"deck_buy" : 0, "type" : "Magia"
	},
	"smallShild" : {
		"description" : "Adiciona 1 de defesa para uma de suas unidades",
		"mana_cost" : 1, "recharge_time" : 2, "deck_return" : "comum",
		"deck_buy" : 0, "type" : "Magia"
	},
	"bigShild" : {
		"description" : "Adiciona 1 de defesa para todas as suas unidades",
		"mana_cost" : 2, "recharge_time" : 3, "deck_return" : "comum",
		"deck_buy" : 0, "type" : "Magia"
	},
	"fastBuy" : {
		"description" : "Compra 2 cartas e ganhe 1 de mana",
		"mana_cost" : 1, "recharge_time" : 4, "deck_return" : "comum",
		"deck_buy" : 0, "type" : "Movimentação"
	}
}
## Dicionário que contem o precarregamento das texturas das cartas
const LETTER_SPRITES = {
	"none" : preload("res://Assets/cartas_back.png"),
	"soldier" : preload("res://Assets/soldier_letter.png"),
	"shilder" : preload("res://Assets/shilder_letter.png"),
	"spikeBall" : preload("res://Assets/spikeBall_letter.png"),
	"undeadSoldier" : preload("res://Assets/undeadSoldier_letter.png"),
	"fireBall" : preload("res://Assets/fireBall_letter.png"),
	"smallShild" : preload("res://Assets/smallShild_letter.png"),
	"bigShild" : preload("res://Assets/bigShild_letter.png"),
	"fastBuy" : preload("res://Assets/fastBuy_letter.png")
}
## Dicionario que contem o precarregamento das cenas das cartas do jogo
const LETTER_SCENES := {
	"soldier" : preload("res://Scenes/letters/soldier_letter.tscn"),
	"shilder" : preload("res://Scenes/letters/shilder_letter.tscn"),
	"spikeBall" : preload("res://Scenes/letters/spike_ball_letter.tscn"),
	"undeadSoldier" : preload("res://Scenes/letters/undead_soldier_letter.tscn"),
	"fireBall" : preload("res://Scenes/letters/fire_ball_letter.tscn"),
	"smallShild" : preload("res://Scenes/letters/small_shild_letter.tscn"),
	"bigShild" : preload("res://Scenes/letters/big_shild_letter.tscn"),
	"fastBuy" : preload("res://Scenes/letters/fast_buy_letter.tscn")
}
## Dicionario que contem os atributos das unidades invocadas em campo (inclui texturas)
const UNITS_ATRIBUTES = {
	"soldier" : {
		"texture" : preload("res://Assets/soldier.png"),
		"power" : 3, "attacks" : 1, "defence" : 1,
		"attack_effect" : -1, "defence_effect" : -1
	},
	"shilder" : {
		"texture" : preload("res://Assets/shilder.png"),
		"power" : 1, "attacks" : 1, "defence" : 3,
		"attack_effect" : -1, "defence_effect" : -1
	},
	"spikeBall" : {
		"texture" : preload("res://Assets/spike_ball.png"),
		"power" : 0, "attacks" : 0, "defence" : 3,
		"attack_effect" : -1, "defence_effect" : DefenceEffects.SPIKE
	},
	"undeadSoldier" : {
		"texture" : preload("res://Assets/undeadSoldierl.png"),
		"power" : 5, "attacks" : 1, "defence" : 1,
		"attack_effect" : AttackEffects.DIE_ON_ATTACK, "defence_effect" : -1
	}
}
#endregion

#region Variaveis de controle de cartas em partida

const MAX_HAND_LETTER := 10
## Controla a quantidade de cartas que o jogador vai comprar por rodada
var buy_letters_count := 2.0

## Controla as cartas que esta na mão do jogador
var letter_in_hand := []
## Controla as cartas que atualmente estão no deck, que o jogador pode comprar
var letter_in_deck := []
## Controla as cartas que estão na linha de recarga/recarregando
var letter_in_recharge := [[], [], [], [], []]
### Os valores são do tipo String  e se referen as chaves dos dicionarios 
### na região "Dicionarios de controle de atributos"
#endregion

## Variavel que contem as cartas escolhidas para a partida atual
var deck := [
	"soldier", "soldier", "soldier", "bigShild", "bigShild", "bigShild",
	"soldier", "soldier", "fastBuy", "fastBuy"
]

## Constante que diz o maximo de mana que o jogador pode ter por rodada
const MAX_MANA := 10
## controla a mana atual do jogador
var mana := 0

var mana_gain := 2.0

# func ready
func _ready() -> void:
	set_deck()

## define o deck do jogo atual como o deck escolhido pelo jogador
func set_deck() -> void:
	for letter in deck:
		letter_in_deck.insert((randi() % (letter_in_deck.size() + 1)), letter)

## Compra uma carta, removendo a 1° carta de "letter_in_deck" e adicionando em "letter_in_hand"
func buy_letter() -> String:
	var next_letter = letter_in_deck.pop_front()
	letter_in_hand.append(next_letter)

	return next_letter

func purchage_letters(quant:int, mg:int) -> void:
	await get_tree().create_timer(.1).timeout
	for a in range(quant):
		hand_controler.instance_letter()
	hand_controler.adjust_letters_pos()
	
	update_mana(-mg)

## Atualiza a mana do jogador, o Label de mana da HUD e impede que tenha mais mana do que "MAX_MANA"
func update_mana(mana_use: int = 0, limit_mana:=true) -> void:
	mana -= mana_use
	if limit_mana and (mana > MAX_MANA):
		mana = MAX_MANA
	mana_contain.update_text()

func hide_next_letters() -> void:
	deck_controler.hide_next_letters()
	deck_controler.button_pressed = false
