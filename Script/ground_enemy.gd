extends EnemyBase

func _ready():
	wall_detcty = $wall_detecty
	animation_enemy = $animation_enemy
	animation_enemy.animation_finished.connect(kill_ground_enemy)

func _physics_process(delta):
	_aply_gravity(delta)
	moviment(delta)
	flip_direction() #Aqui a função é chamada
