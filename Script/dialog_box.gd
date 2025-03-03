extends MarginContainer



@onready var text_label: Label = $label_margin/text_label
@onready var letter_timer_display: Timer = $letter_timer_display

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_display_time := 0.07
var space_display_time := 0.05
var punctuaction_display_time := 0.2

signal text_display_finished()

func display_text(text_to_display: String):
	text = text_to_display
	text_label.text = text_to_display  # Define o texto completo primeiro para calcular o tamanho
	await resized  # Aguarda o cálculo do tamanho inicial
	
	# Define o tamanho máximo da caixa de diálogo
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	# Ajusta a quebra automática de linha
	if size.x > MAX_WIDTH:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD  # Habilita quebra de linha por palavra
		await resized  # Aguarda a redefinição do tamanho após ativar o autowrap
		custom_minimum_size.y = size.y  # Ajusta a altura mínima com base no novo tamanho
	
	# Posiciona a caixa de diálogo corretamente
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24

	# Inicializa o texto para exibição gradual
	text_label.text = ""
	letter_index = 0  # Certifique-se de reiniciar o índice
	display_letter()
	

func display_letter():
	text_label.text += text[letter_index]
	letter_index += 1
	
	if letter_index >= text.length():
		text_display_finished.emit()
		return
		
	match text[letter_index]:
		"!", "?", ",", ".":
			letter_timer_display.start(punctuaction_display_time)
		" ":
			letter_timer_display.start(space_display_time)
		_:
			letter_timer_display.start(letter_display_time)
			

func _on_letter_timer_display_timeout():
	if letter_index < text.length():
		display_letter()
