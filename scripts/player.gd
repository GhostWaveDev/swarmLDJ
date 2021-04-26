extends KinematicBody2D

class_name Player
 
const MOVE_SPEED = 5
const DEACCEL = 10
const MAX_MOVE_SPEED = 300
const JUMP_FORCE = 420
const GRAVITY = 20
const MAX_FALL_SPEED = 1000
const WAIT_TIME_CHARGED_JUMP = 1

onready var sprite = $sprite

var facing_right = false
var velocity = Vector2(0,1)
var ducked = false
var timeWaitCharged = 0
var groundedCache = false
var floorTile = 0

var bloopscene = preload("res://scenes/bloop.tscn")

var die_thread

var scoreManager
var livesManager
var camera

export var controllable = false
var state = 1 #0: Idle, 1: Right, 2: Left

func _ready():
	die_thread = Thread.new()
	scoreManager = get_parent().get_node("Camera2D/score")
	livesManager = get_parent().get_node("Camera2D/lives")
	camera = get_parent().get_node("Camera2D")

func _physics_process(delta):
	var move_dir = 0
	if Input.is_action_pressed("rightArrow") and controllable:
		move_dir += 1
	if Input.is_action_pressed("leftArrow") and controllable:
		move_dir -= 1
	if !controllable:
		move_dir = state
	
	
	move_and_slide(velocity, Vector2(0, -1))
 
	var grounded = is_on_floor() or (groundedCache and velocity.y == 0 and floorTile > 0)
	groundedCache = grounded
	 
	velocity.x = velocity.x + (move_dir * MOVE_SPEED * MAX_MOVE_SPEED * delta)
	
	
	if velocity.x < 0 and move_dir > -1:
		velocity.x = velocity.x + (DEACCEL * MAX_MOVE_SPEED * delta)
		if velocity.x > 0:
			velocity.x = 0
	
	elif velocity.x > 0 and move_dir < 1:
		velocity.x = velocity.x - (DEACCEL * MAX_MOVE_SPEED * delta)
		if velocity.x < 0:
			velocity.x = 0
	
	if velocity.x > MAX_MOVE_SPEED:
		velocity.x = MAX_MOVE_SPEED
	elif velocity.x < -MAX_MOVE_SPEED:
		velocity.x = -MAX_MOVE_SPEED
	
	if !grounded:
		velocity.y += GRAVITY
		
	if grounded:
		velocity.y = 0
	
	if grounded and Input.is_action_pressed("upArrow") and ducked == false and controllable:
		velocity.y -= JUMP_FORCE
	
	if grounded and Input.is_action_just_released("downArrow") and timeWaitCharged > WAIT_TIME_CHARGED_JUMP:
		velocity.y -= JUMP_FORCE * 1.4
	
	if grounded and Input.is_action_pressed("downArrow") and controllable:
		ducked = true
	else:
		ducked = false
	
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
 
	if facing_right and move_dir < 0:
		flip()
	if !facing_right and move_dir > 0:
		flip()
	
	if grounded:
		if move_dir == 0:
			if ducked:
				if timeWaitCharged > WAIT_TIME_CHARGED_JUMP:
					play_anim("charged")
				else:
					play_anim("duck")
			else:
				play_anim("idle")
		else:
			ducked = false
			play_anim("walk")
	else:
		play_anim("jump")
	
	if ducked:
		timeWaitCharged += delta
	else:
		timeWaitCharged = 0
	
	if self.global_position.y > 700 * camera.stage:
		self.queue_free()
		livesManager.loseLife()
 
func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
 
func play_anim(anim_name):
	if sprite.is_playing() and sprite.animation == anim_name:
		return
	
	if sprite.animation != anim_name:
		sprite.animation = anim_name
	
	if anim_name != "duck":
		sprite.playing = true

func _on_sprite_animation_finished():
	if sprite.animation == "duck":
		sprite.playing = false
		sprite.frame = 1
	

func _on_floorArea_body_shape_exited(body_id, body, body_shape, area_shape):
	floorTile -= 1

func _on_floorArea_body_shape_entered(body_id, body, body_shape, area_shape):
	floorTile += 1

func die():
	spawn_blood(0)
	$aww.play()
	scoreManager.addScore(10)

func spawn_blood(userdata):
	var snapPos = Vector2(int(self.position.x), int(self.position.y))
	
	get_parent().get_node("powderToy").add_body(snapPos, true)
	self.queue_free()

func _exit_tree():
	die_thread.wait_to_finish()
