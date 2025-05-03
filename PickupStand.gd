extends Node2D

func _on_Area2D_body_entered(body):
	if body.name == "Player" and not body.is_carrying:
		body.pick_up_marshmallow()
