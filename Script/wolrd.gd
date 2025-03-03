extends Node2D

@onready var player := $Player as CharacterBody2D
@onready var player_scene = preload("res://Actors/player.tscn")

@onready var camera := $Camera as Camera2D
@onready var control: Control = $HUD/control
@onready var player_start_position: Marker2D = $player_start_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globlas.player_start_position = player_start_position
	Globlas.player = player
	Globlas.player.follow_camera(camera)
	Globlas.player.player_has_died.connect(reload_game)
	control.time_is_up.connect(game_over)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reload_game():
	await get_tree().create_timer(1.0).timeout
	var player = player_scene.instantiate()
	add_child(player)
	if Globlas.current_checkpoint == null:
		control.reset_clock_timer()
		game_over() #Aparentemente isso causa o erro
	Globlas.player = player
	Globlas.player.follow_camera(camera) #Erro é chamado aqui
	Globlas.player.player_has_died.connect(game_over)
	
	#Resetando os valores globais
	Globlas.coins = 0
	Globlas.score = 0
	Globlas.player_life = 3
	
	Globlas.respawn_player()
	
func game_over():
	get_tree().change_scene_to_file("res://Itens/game_over.tscn")
	
	
	
	
