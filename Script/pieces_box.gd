extends RigidBody2D




func _on_notifier_pieces_screen_exited():
	queue_free()
