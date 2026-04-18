extends Area2D

signal change_sprite(value: bool)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("parasite"):
		#change_sprite.emit(true)
		#body.hide_sprite()
		print("parasite on")


func _on_body_exited(body: Node2D) -> void:
	#change_sprite.emit(false)
	print("parasite off")
