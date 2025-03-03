extends Area2D

@onready var sprite_spike: Sprite2D = $sprite_spike
@onready var collision_spike: CollisionShape2D = $collision_spike

@export var tamanho: Vector2 = Vector2(8,8) #Valor inicial padrão 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Atualiza o tamanho do region_rect
	var novo_rect = sprite_spike.region_rect
	novo_rect.size = tamanho
	sprite_spike.region_rect = novo_rect
	
	collision_spike.shape.size = sprite_spike.get_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_body_entered(body):
	if body.name == "Player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
