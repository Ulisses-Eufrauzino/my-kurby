extends Area2D

var is_active = false
@onready var animate_check: AnimatedSprite2D = $animate_check
@onready var checkpoint_sfx: AudioStreamPlayer = $checkpoint_sfx


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player" or is_active:
		return
	checkpoint_active()

func checkpoint_active():
	Globlas.current_checkpoint = self
	animate_check.play("raising")
	is_active = true
	checkpoint_sfx.play()

func _on_animate_check_animation_finished() -> void:
	if animate_check.animation == "raising":
		animate_check.play("checked")
