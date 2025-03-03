extends Node


@onready var dialog_box_scene = preload("res://Itens/dialog_box.tscn")
var message_lines: Array[String] = []
var current_line = 0

var dialog_box
var dialog_box_position := Vector2.ZERO

var is_message_active := false
var can_advence_message := false

func start_message(position: Vector2, lines: Array[String]):
	if is_message_active:
		return
		
	message_lines = lines
	dialog_box_position = position
	show_text()
	is_message_active = true
	
func show_text():
	# Verifica se dialog_box ainda é válido antes de liberar
	if dialog_box:
		if not dialog_box.is_queued_for_deletion():
			dialog_box.queue_free()
		dialog_box = null  # Limpa a referência para evitar problemas futuros
		
	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	add_child(dialog_box)
	dialog_box.global_position = dialog_box_position
	dialog_box.display_text(message_lines[current_line])
	can_advence_message = false
	
func _on_all_text_displayed():
	can_advence_message = true
	
func _unhandled_input(event):
	if event.is_action_pressed("advance_message") and is_message_active and can_advence_message:
		if dialog_box and not dialog_box.is_queued_for_deletion():
			dialog_box.queue_free()  # Verifica antes de liberar
		current_line += 1
		if current_line >= message_lines.size():
			is_message_active = false
			current_line = 0
			return
		show_text()
