extends Node2D

const FALL_SPEED = 20

var velocity = Vector2(0,0)

var going_down = true

var timerStarted = false


func _process(delta):
	
	self.position += velocity * delta
	
	if self.position.y < 10 and going_down:
		
		velocity[1] += FALL_SPEED
	
	if self.position.y > 10 and going_down:
		
		going_down = false
		
		self.position.y = 10
		
		velocity = Vector2.ZERO
	
	if self.position.y == 10 and not(going_down) and not(timerStarted):
		get_parent().get_node("sound").play()
		$timer.start()
		timerStarted = true
	
	if self.position.y < -10 and not(going_down):
		
		self.queue_free()


func _on_timer_timeout():
	velocity = Vector2(0, -40)
	timerStarted = false
