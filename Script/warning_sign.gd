extends Node2D


@onready var sprite_sign: Sprite2D = $sprite_sign
@onready var area_sign: Area2D = $area_sign
@onready var dialog_manager = get_parent().get_node("/root/DialogMenager")  # Certifique-se de que o caminho está correto

const lines: Array[String] = [
	"Olá amigo!",
	"Bem vindo ao My Kurby",
	"A diversos desafios a serem enfrentados",
	"Tenho certeza que você ficará bem!",
	"Boa sorte!",
]

func _process(delta):
	if area_sign.get_overlapping_bodies().size() > 0:
		sprite_sign.show()
	else:
		sprite_sign.hide()
		# Se o jogador sair da área, reseta o diálogo
		if dialog_manager.is_message_active:
			dialog_manager.dialog_box.queue_free()
			dialog_manager.is_message_active = false
			dialog_manager.current_line = 0  # Reinicia o índice das linhas

func _unhandled_input(event):
	if area_sign.get_overlapping_bodies().size() > 0:
		if DialogMenager.is_message_active:
			sprite_sign.hide()  # Esconde o ícone enquanto o diálogo está ativo
		else:
			sprite_sign.show()  # Mostra o ícone se o jogador está próximo e o diálogo não está ativo
		
		if event.is_action_pressed("interact") and not DialogMenager.is_message_active:
			sprite_sign.hide()  # Esconde o ícone quando o diálogo começa
			DialogMenager.start_message(global_position, lines)
	else:
		sprite_sign.hide()  # Esconde o ícone se o jogador se afasta
