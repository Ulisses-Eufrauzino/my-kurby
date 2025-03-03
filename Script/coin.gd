extends Area2D

var coins := 1
@onready var coin_sfx: AudioStreamPlayer = $coin_sfx

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
	

func _on_anim_animation_finished() -> void:
	queue_free()
