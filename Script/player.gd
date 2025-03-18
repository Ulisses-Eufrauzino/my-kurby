extends CharacterBody2D


const SPEED = 300.0
const AIR_FRICTION := 0.5

const COIN_SCENE := preload("res://Itens/rigid_coin.tscn")

var is_jumping = false
var knockback_vector := Vector2.ZERO
var knockback_power := 20
var direction
var is_hurted := false

#handle jump and gravity
@export var jump_height := 180
@export var max_time_to_peak := 0.6

var jump_velocity
var gravity
var fall_gravity

@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_player := $remote_player as RemoteTransform2D
@onready var jump_sfx: AudioStreamPlayer = $jump_sfx
@onready var destroy_sfx = preload("res://Sounds/destroy_sfx.tscn")
@onready var hurtbox_sfx: AudioStreamPlayer = $hurtbox_sfx

signal player_has_died()

func _ready() -> void:
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
	fall_gravity = gravity * 2

func _process(delta: float) -> void:
	add_life_collection_coin()

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("ui_left", "ui_right")
	# Add the gravity.
	if not is_on_floor():
		if direction == 1:
			velocity.x = 100
		elif direction == -1:
			velocity.x = -100
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_velocity
		is_jumping = true
		jump_sfx.play()
	elif is_on_floor():
		is_jumping = false
		
	if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
	
	
func _on_hurtbox_body_entered(body):
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	take_damage(knockback)
	hurtbox_sfx.play()
		
	if body.is_in_group("fireball"):
		body.queue_free()
	
		
func follow_camera(camera):
	if not is_inside_tree(): #Garante que o nó ainda está na cena
		return
		
	if camera == null:
		print("Camera não encontrada!") #Verifica se a câmera é válida
		return
	
	var camera_path = camera.get_path() #E aqui também
	remote_player.remote_path = camera_path
	
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globlas.player_life > 0:
		Globlas.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
		
	lose_coins()
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false

func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if is_hurted:
		state = "hurt"
		
	if animation.name != state:
		animation.play(state)


func _on_colision_header_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 0:
			body.break_sprite()
			play_destroy_sfx()
		else:
			body.animation_box_bk.play("hit")
			body.hit_block.play()
			body.create_coin()
	
func play_destroy_sfx():
	var sound_sfx = destroy_sfx.instantiate()
	get_parent().add_child(sound_sfx)
	sound_sfx.play()
	await sound_sfx.finished
	sound_sfx.queue_free()
	
	
func lose_coins():
	#Lembre-se do método min()
	var lost_coins: int = Globlas.coins
	$CollisionShape2D.set_deferred("disabled", true)
	Globlas.coins -= lost_coins
	Globlas.count_coins = 0
	for i in lost_coins:
		var rigid_coin = COIN_SCENE.instantiate()
		rigid_coin.z_index = 1
		#get_parent().add_child(coin) Assim dá erro por algum motivo
		get_parent().call_deferred("add_child", rigid_coin)
		rigid_coin.global_position = global_position
		if lost_coins <= 50:
			rigid_coin.apply_impulse(Vector2(randi_range(-200, 200), -250))
			rigid_coin.call_deferred("set_from_player") # 📌 Aqui marcamos que a moeda veio do jogador!
		else:
			rigid_coin.apply_impulse(Vector2(randi_range(-400, 400), -450))
			rigid_coin.call_deferred("set_from_player") # 📌 Aqui marcamos que a moeda veio do jogador!
	await get_tree().create_timer(0.03).timeout
	$CollisionShape2D.set_deferred("disabled", false)
	
	
	
func handle_death_zone():
	if Globlas.player_life > 0:
		Globlas.player_life -= 1
		visible = false
		set_physics_process(false)
		
		await get_tree().create_timer(1.0).timeout
		Globlas.respawn_player()
		visible = true
		set_physics_process(true)
	else:
		visible = false
		await get_tree().create_timer(0.5).timeout
		player_has_died.emit()
	
func add_life_collection_coin():
	while Globlas.count_coins == 30:
		Globlas.player_life += 1
		Globlas.count_coins = 0
	
	
	
	
	
	
	
	
	
	
	
