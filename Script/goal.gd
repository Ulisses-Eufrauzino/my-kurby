extends Area2D

@onready var transition: CanvasLayer = $"../transition"
@export var next_level: String = ""
@onready var level_up_sfx: AudioStreamPlayer = $level_up_sfx

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !next_level == "":
		transition.change_scene(next_level)
		level_up_sfx.play()
	else:
		print("No scene loaded")
