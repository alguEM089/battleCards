extends Node

#region Referencia de nós
## O tabuleiro onde são invocada as unidades
var tabuleiro : ColorRect
## Label que mostra a quantia de mana atual
var label_mana : Label
## Linha de racarga que mostra o tempo (em rodadas) para as cartas usadas voltarem para mesa
var recharge_line : RechargeLine
## Nó que controla as cartas que estão na mão do jogador
var hand_controler : Node2D
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
		"mana_cost" : 1, "recharge_time" : 1, "deck_return" : "comum",
		"deck_buy" : 0, "type" : "Unidade"
	},
	"undeadSoldier" : {
		"description" : "Invoca uma unidade de 1 ataque, com 5 de dano e 2 defesa. Se destroi ao atacar.",
		"mana_cost" : 1, "recharge_time" : 2, "deck_return" : "priority",
		"deck_buy" : 0, "type" : "Unidade"
	}
}
## Dicionário que contem o precarregamento das texturas das cartas
const LETTER_SPRITES = {
	"soldier" : preload("res://Assets/soldier_letter.png"),
	"shilder" : preload("res://Assets/shilder_letter.png"),
	"spikeBall" : preload("res://Assets/spikeBall_letter.png"),
	"undeadSoldier" : preload("res://Assets/undeadSoldier_letter.png")
}
## Dicionario que contem o precarregamento das cenas das cartas do jogo
const LETTER_SCENES := {
	"soldier" : preload("res://Scenes/letters/soldier_letter.tscn"),
	"shilder" : preload("res://Scenes/letters/shilder_letter.tscn"),
	"spikeBall" : preload("res://Scenes/letters/spikeBall_letter.tscn"),
	"undeadSoldier" : preload("res://Scenes/letters/undeadSoldier_letter.tscn")
}
## Dicionario que contem os atributos das unidades invocadas em campo (inclui texturas)
const UNITS_ATRIBUTES = {
	"soldier" : {
		"texture" : preload("res://Assets/soldier.png"),
		"power" : 3, "atacks" : 1, "defence" : 1
	},
	"shilder" : {
		"texture" : preload("res://Assets/shilder.png"),
		"power" : 1, "atacks" : 1, "defence" : 3
	},
	"spikeBall" : {
		"texture" : preload("res://Assets/spike_ball.png"),
		"power" : 0, "atacks" : 1, "defence" : 3
	},
	"undeadSoldier" : {
		"texture" : preload("res://Assets/undeadSoldierl.png"),
		"power" : 5, "atacks" : 1, "defence" : 1
	}
}
#endregion

#region Variaveis de controle de cartas em partida
## Controla as cartas que esta na mão do jogador
var letter_in_hand := []
## Controla as cartas que atualmente estão no deck, que o jogador pode comprar
var letter_in_deck := []
## Controla as cartas que estão na linha de recarga/recarregando
var letter_in_recharge := [[], [], [], [], []]
## controla as unidades que estão em campo
var units_space := [
		null, null, null, null, null, 
		null, null, null, null, null
]
### Os valores são do tipo String  e se referen as chaves dos dicionarios 
### na região "Dicionarios de controle de atributos"
#endregion

## Constante que diz o maximo de mana que o jogador pode ter por rodada
const MAX_MANA := 10
## Variavel que contem as cartas escolhidas para a partida atual
var deck := [
	"spikeBall", "shilder", "undeadSoldier", "soldier", "shilder",
	"soldier", "spikeBall", "shilder", "soldier", "soldier",
	"spikeBall", "shilder", "undeadSoldier", "soldier", "shilder",
	"soldier", "spikeBall", "shilder", "soldier", "soldier",
	"spikeBall", "shilder", "undeadSoldier", "soldier", "shilder",
	"soldier", "spikeBall", "shilder", "soldier", "soldier"
]

## controla a mana atual do jogador
var mana := 10
## Controla a quantidade de cartas que o jogador vai comprar por rodada
var buy_letters_count := 2

# func ready
func _ready() -> void:
	set_deck()
	for a in range(10):
		print(ReturnDeck.priority())

## define o deck do jogo atual como o deck escolhido pelo jogador
func set_deck() -> void:
	for letter in deck:
		letter_in_deck.insert((randi() % (letter_in_deck.size() + 1)), letter)

## Compra uma carta, removendo a 1° carta de "letter_in_deck" e adicionando em "letter_in_hand"
func buy_letter() -> String:
	var next_letter = letter_in_deck.pop_front()
	letter_in_hand.append(next_letter)

	return next_letter

## Atualiza a mana do jogador, o Label de mana da HUD e impede que tenha mais mana do que "MAX_MANA"
func update_mana(mana_use: int) -> void:
	mana -= mana_use
	if mana > MAX_MANA:
		mana = MAX_MANA
	label_mana.update_text()
