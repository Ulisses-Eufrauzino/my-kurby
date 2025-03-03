extends EnemyBase

@onready var spawn_enemy: Marker2D = $"../spawn_enemy"
	

func _ready() -> void:
	animation_enemy = $animation_enemy
	spawn_instance = preload("res://Actors/cherry.tscn")
	spawn_instance_position = spawn_enemy
	can_spawn = true
	animation_enemy.animation_finished.connect(kill_air_enemy)
