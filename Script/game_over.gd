extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globlas.coins = 0
	Globlas.score = 0
	Globlas.player_life = 3


func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Itens/title_screen.tscn")



func _on_quit_btn_pressed() -> void:
	get_tree().quit()
