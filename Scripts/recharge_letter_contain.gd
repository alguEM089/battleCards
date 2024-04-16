extends Node2D
## Variavel que diz se o nó está mostrando ou não as cartas na linha de recarga
var is_show_letters := false

## move as cartas para que todas sejam visiveis para o player
func show_letters() -> void:
	if !is_show_letters:
		for letter in get_children():
			var tween = create_tween()
			tween.tween_property(
				letter, "position", Vector2(65 * letter.get_index(), letter.position.y), 0.1
			)
		is_show_letters = true
	else:
		for letter in get_children():
			var tween = create_tween()
			tween.tween_property(
				letter, "position", Vector2(0, letter.position.y), 0.1
			)
		is_show_letters = false
