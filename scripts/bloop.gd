extends Node2D


var possible_colors = [Color("41de95"), Color("2aa4aa"), Color("2aa4aa"), Color("2aa4aa"), Color("b54131")]

func _ready():
	$bloopBloop.linear_velocity = Vector2(rand_range(-1000, 1000), rand_range(-800, 800))
	$bloopBloop/sprite.frame = randi() % 5 
	$bloopBloop/sprite.position.y = randi() % 5 + 3
	$bloopBloop/sprite.flip_h = randi() % 2
	$bloopBloop/sprite.modulate = possible_colors[randi() % len(possible_colors)]
	
	yield(get_tree().create_timer(0.3), "timeout")
	self.visible = true

#func _physics_process(delta):
#	move_and_slide(velocity, Vector2(0, -1))
#
#	if velocity.x < 0:
#		velocity.x = velocity.x + DEACCEL * delta
#		if velocity.x > 0:
#			velocity.x = 0
#
#	if velocity.x > 0:
#		velocity.x = velocity.x - DEACCEL * delta
#		if velocity.x < 0:
#			velocity.x = 0
#
#	velocity.y += GRAVITY
#
#func setVelocity(vec : Vector2):
#	velocity = vec

