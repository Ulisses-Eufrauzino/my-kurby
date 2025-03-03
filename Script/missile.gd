extends AnimatableBody2D

const SPEED := 500.0
const EXPLOSION := preload("res://Itens/explosion.tscn")

var velocity := Vector2.ZERO
var direction
@onready var sprite: Sprite2D = $sprite
@onready var missile_collision: CollisionShape2D = $missile_collision
@onready var collision: CollisionShape2D = $collision_detection/collision

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x = SPEED * direction * delta
	
	move_and_collide(velocity)

func set_direction(dir):
	direction = dir
	if direction == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _on_collision_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage()
	visible = false
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	missile_collision.set_deferred("disabled", true)
	collision.set_deferred("disabled", true)
	await explosion_instance.animation_finished
	queue_free()
