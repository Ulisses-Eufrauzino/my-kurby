extends RocketCherry

@onready var cherry_visible: VisibleOnScreenEnabler2D = $cherry_visible

func _ready():
	wall_detcty = $wall_detecty
	animation_enemy = $animation_enemy
	animation_enemy.animation_finished.connect(kill_air_enemy)
	cherry_visible.set_deferred("enabled", false)

func _physics_process(delta):
	_aply_gravity(delta)
	moviment(delta)
	flip_direction()
	
	#Garante que só ative o VisibleOnScreenEnabler2D se a condição for atendida
	if base_patrol and base_patrol.has_method("cherry_visible_on_screen"):
		if base_patrol.cherry_visble_on_screen:
			cherry_visible.set_deferred("enabled", true)


func _on_cherry_visible_screen_exited() -> void:
	#Carrega a cena de RocketCherry
	var rocket_cherry_scene = preload("res://Actors/base_patrol.tscn")
	if not rocket_cherry_scene:
		push_error("Erro: Não foi possível carregar a cena rocket_cherry.tcsn!")
		return
		
	var rocket_cherry_instance = rocket_cherry_scene.instantiate()
	if not rocket_cherry_instance:
		push_error("Error: Não foi possível instanciar rocket_cherry.tcsn!")
		return
	
	#Obtém o nó principal da cena
	var world_node = get_tree().get_current_scene()
	if not world_node:
		push_error("Erro: cena atual não encontrada!")
	
	world_node.add_child(rocket_cherry_instance) #Adiciona ao nó correto
	await get_tree().create_timer(5).timeout
	
	#Verifica novamente se a instância ainda existe antes de definir a posição
	if is_instance_valid(rocket_cherry_instance):
		rocket_cherry_instance.global_position = Vector2(4758.0, -104.0)
	else:
		push_error("Error: rocket_cherry_instance foi excluído antes de definir a posição!")
	
	
	
	#Remove o inimigo original
	queue_free()
