extends CharacterBody2D

const FIREBALL = preload("res://Itens/fireball.tscn")

var move_speed := 150.0
var direction := 1
var health_points := 3
@onready var sprite: Sprite2D = $sprite
@onready var animation_enemy: AnimationPlayer = $animation_enemy
@onready var fireball_spawn_point: Marker2D = $fireball_spawn_point
@onready var ground_detector: RayCast2D = $ground_detector
@onready var player_detector: RayCast2D = $player_detector

enum EnemyState {PATROL, ATTACK, HURT}
var currente_state = EnemyState.PATROL
@export var target : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	match(currente_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.ATTACK : attack_state()
	
func patrol_state():
	animation_enemy.play("running")
	if is_on_wall():
		flip_enemy()
		
	if not ground_detector.is_colliding():
		flip_enemy()
	
	velocity.x = move_speed * direction
	
	if player_detector.is_colliding():
		_change_state(EnemyState.ATTACK)
	
	move_and_slide()
	
func attack_state():
	animation_enemy.play("shooting")
	if not player_detector.is_colliding():
			_change_state(EnemyState.PATROL)
			
func hurt_state():
	animation_enemy.play("hurt")
	await get_tree().create_timer(0.3).timeout
	_change_state(EnemyState.PATROL)
	
	if health_points > 0:
		health_points -= 1
	else:
		queue_free()
	
func _change_state(state):
	currente_state = state
	
func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	fireball_spawn_point.position.x *= -1
	
	
func spawn_fireball():
	var new_fireball = FIREBALL.instantiate()
	if sign(fireball_spawn_point.position.x) == 1:
		new_fireball.set_direction(1)
	else:
		new_fireball.set_direction(-1)
	add_sibling(new_fireball)
	new_fireball.global_position = fireball_spawn_point.global_position
	

func _on_hitbox_body_entered(body: Node2D) -> void:
	_change_state(EnemyState.HURT)
	hurt_state()
