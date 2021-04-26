extends Area2D

export var collisionShapeSize = Vector2.ZERO
export var active : bool = true

func _ready():
	if collisionShapeSize != Vector2.ZERO:
		$collisionShape.shape = RectangleShape2D.new()
		$collisionShape.shape.set_extents(collisionShapeSize)

func _on_killzone_body_entered(body):
	if body is Player and active:
		body.die()
