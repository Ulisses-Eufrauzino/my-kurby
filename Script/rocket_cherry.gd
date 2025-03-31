extends EnemyBase
class_name RocketCherry

@onready var spawn_enemy: Marker2D = $"../spawn_enemy"
@onready var base_patrol: BaseRocket = get_parent() as BaseRocket #Corrigido para evitar erros



func _ready() -> void:
	animation_enemy = $animation_enemy
	spawn_instance = preload("res://Actors/cherry.tscn")
	spawn_instance_position = spawn_enemy
	can_spawn = true
	animation_enemy.animation_finished.connect(kill_air_enemy)
	
func spawn_new_enemy():
	if spawn_instance:
		var instance_scene = spawn_instance.instantiate()
		var world_node = get_tree().get_current_scene()

		if world_node:
			world_node.add_child(instance_scene)
			instance_scene.global_position = global_position + Vector2(0, 50)  # Spawna um pouco abaixo
		else:
			push_error("Erro ao encontrar a cena atual!")
	else:
		push_error("Erro: spawn_instance está null!")
