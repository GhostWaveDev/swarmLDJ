extends Node2D

const MOVE_SPEED = 10

var velocity = Vector2(0,0)

func _ready():
	
	velocity.x = -MOVE_SPEED

func _process(delta): 
	
	self.position += velocity * delta
