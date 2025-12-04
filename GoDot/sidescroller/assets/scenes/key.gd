extends Area2D

func key_entered(body):
	if body is PlayerController:
		GameManager.add_key()
		queue_free()
