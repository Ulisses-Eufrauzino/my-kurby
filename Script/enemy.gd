extends CharacterBody2D
class_name EnemyBase

const SPEED = 3000.0
const JUMP_VELOCITY = -400.0

@export var enemy_score := 100

var wall_detcty = null
var animation_enemy
var direction := -1

var can_spawn = false
var spawn_instance: PackedScene = null
var spawn_instance_position

func _physics_process(delta: float) -> void:
	pass
		

func _aply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
func moviment(delta):
	velocity.x = direction * SPEED * delta

	move_and_slide()
	
func flip_direction():
	if wall_detcty.is_colliding():
		direction *= -1
		wall_detcty.scale.x *= -1
		
	if direction == 1:
		animation_enemy.flip_h = true
	else:
		animation_enemy.flip_h = false
	
	
		

func kill_ground_enemy():
		kill_and_score()
		
func kill_air_enemy():
	kill_and_score()
	
func kill_and_score():
	Globlas.score += enemy_score
	queue_free()
	if can_spawn:
		spawn_new_enemy()
		get_parent().queue_free()
	else:
		queue_free()

func spawn_new_enemy():
	var instance_scene = spawn_instance.instantiate()
	var world_node = get_tree().get_current_scene() #Obtém o nó principal da cena stual
	
	if world_node:
		world_node.add_child(instance_scene) #Adiciona ao nó correto
	else:
		push_error("Error: Cena atual não encontrada!")
		
	instance_scene.global_position = spawn_instance_position.global_position
	
	
	
	
	
	
	
	
