extends Area2D

export var type = ""

func _on_waypoint_body_entered(body):
	if body is Player:
		if type == "change":
			body.state = -body.state
		if type == "jump":
			body.jump()
