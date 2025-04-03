extends CharacterBody2D

const BOMB := preload("res://Itens/bomb.tscn")
const MISSILE := preload("res://Itens/missile.tscn")
const MOVE_PLATFORM := preload("res://Itens/moviment_plataform.tscn")
const SPEED = 15000.0
var direction = -1
@onready var wall_detector: RayCast2D = $wall_detector
@onready var sprite: Sprite2D = $sprite
@onready var missile_point: Marker2D = %missile_point
@onready var bomb_point: Marker2D = %bomb_point
@onready var shot_sfx: AudioStreamPlayer = $shot_sfx
@onready var final_boss_sfx: AudioStreamPlayer = $final_boss_sfx
@onready var bg_music: AudioStreamPlayer = $"../bg_music"
@onready var explosiom_sfx: AudioStreamPlayer = $explosiom_sfx

@onready var anim_tree: AnimationTree = $anim_tree
@onready var state_machine = anim_tree["parameters/playback"]

#Flags para estados do BOSS
var turn_count := 0
var missile_count := 0
var bomb_count := 0
var can_launch_missile := true
var can_launch_bomb := true
var player_hit := false
var boss_life := 5

@export var boss_instance: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		turn_count += 1
	
	
		
	
	match state_machine.get_current_node():
		"moving":
			$hurtbox/collision.set_deferred("disabled", true)
			$Area2D/CollisionShape2D.set_deferred("disabled", false)
			if direction == 1:
				velocity.x = SPEED * delta
				sprite.flip_h = true
			else:
				velocity.x = -SPEED * delta
				sprite.flip_h = false
		"missile_attack":
			velocity.x = 0
			await get_tree().create_timer(2.0).timeout
			if can_launch_missile:
				launch_missile()
				can_launch_missile = false
		"hide_bomb":
			velocity.x = 0
			await get_tree().create_timer(2.0).timeout
			if can_launch_bomb:
				throw_bomb()
				can_launch_bomb = false
		"vunerable":
			can_launch_bomb = false
			can_launch_missile = false
			await get_tree().create_timer(2.0).timeout
			player_hit = false
			$hurtbox/collision.set_deferred("disabled", false)
			$Area2D/CollisionShape2D.set_deferred("disabled", true)
			
	if turn_count <= 2:
		anim_tree.set("parameters/conditions/can_move", true)
		anim_tree.set("parameters/conditions/time_missile", false)
	elif missile_count >= 4:
		anim_tree.set("parameters/conditions/time_bomb", true)
		missile_count = 0
	elif bomb_count >= 6:
		anim_tree.set("parameters/conditions/is_vunerable", true)
		bomb_count = 0
	else:
		anim_tree.set("parameters/conditions/can_move", false)
		anim_tree.set("parameters/conditions/is_vunerable", false)
		anim_tree.set("parameters/conditions/time_bomb", false)
		anim_tree.set("parameters/conditions/time_missile", true)
		
		
	if boss_life <= 0:
		state_machine.travel("death")
		
	move_and_slide()
	
	
func throw_bomb():
	if bomb_count <= 6:
		var bomb_instance = BOMB.instantiate()
		add_sibling(bomb_instance)
		bomb_instance.global_position = bomb_point.global_position
		bomb_instance.apply_impulse(Vector2(randi_range(direction * 200, direction * 700), randi_range(-400, -600)))
		$bomb_cooldown.start()
		shot_sfx.play()
		bomb_count += 1
	

func launch_missile():
	if missile_count <= 4:
		var missile_instance = MISSILE.instantiate()
		add_sibling(missile_instance)
		missile_instance.global_position = missile_point.global_position
		missile_instance.set_direction(direction)
		$missile_cooldown.start()
		shot_sfx.play()
		missile_count += 1


func _on_bomb_cooldown_timeout() -> void:
	can_launch_bomb = true
	

func _on_missile_cooldown_timeout() -> void:
	can_launch_missile = true


func _on_player_detector_body_entered(body: Node2D) -> void:
	set_physics_process(true)
	

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	set_physics_process(true)
	bg_music.stop()
	final_boss_sfx.play()
	


func _on_hurtbox_body_entered(body: Node2D) -> void:
	body.velocity = Vector2(50, -300)
	boss_life -= 1
	player_hit = true
	turn_count = 0


func create_lose_boss():
	explosiom_sfx.play()
	var boss_scene = boss_instance.instantiate()
	add_child(boss_scene)
	boss_scene.global_position = position
	spawn_move_platform()
	await get_tree().create_timer(1).timeout
	final_boss_sfx.stop()
	bg_music.play()
	
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
		

func spawn_move_platform():
	var platform_instance = MOVE_PLATFORM.instantiate()
	platform_instance.distance = 50
	platform_instance.move_horizontal = false
	platform_instance.scale = Vector2(0.7, 0.7)
	add_child(platform_instance)
	platform_instance.global_position = Vector2(2009.0, 479.0)
