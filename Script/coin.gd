extends Area2D

var coins := 1
var from_player := false # Controla se a moeda foi perdida pelo jogador

@onready var coin_sfx: AudioStreamPlayer = $coin_sfx

signal set_from_player()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	$anim.play("collection")
	coin_sfx.play()
	await $CollisionShape2D.call_deferred("queue_free") #Evita pegar duas moedas
	Globlas.coins += coins
	Globlas.count_coins += coins
	print(Globlas.count_coins)
	


func _on_anim_animation_finished() -> void:
	queue_free()
	

func on_set_from_player():
	from_player = true
	print("Moeda marcada como from_player")
	$anim.play("delete") # Toca a animação de desaparecimento
	await get_tree().create_timer(2.0).timeout # Espera 1 segundo
	queue_free() # Remove a moeda
