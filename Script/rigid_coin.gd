extends RigidBody2D

var coin  #Para armazenar o nó

func _ready() -> void:
	coin = get_node_or_null("coin") #Assim pega o nó com segurança

func _on_coin_tree_exited() -> void:
	queue_free() #Remove o item de colisão

func set_from_player():
	if coin:
		coin.on_set_from_player()
	else:
		print("❌ ERRO: Coin não está acessível no RigidBody2D!")
