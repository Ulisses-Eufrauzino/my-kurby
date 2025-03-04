extends Area2D
@onready var kick_sfx: AudioStreamPlayer = $kick_sfx

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity.y = -body.jump_velocity
		get_parent().animation_enemy.play("hurt")
		kick_sfx.play()
