extends Camera2D

const SPEED = 20

var target = Vector2(54, 40)
var stage = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	if self.position.y < target.y and stage == 2:
		self.position.y += SPEED * delta
		if self.position.y > target.y:
			self.position.y = target.y
			get_parent().get_node("spawner").active = true
			get_parent().get_node("spawner").reset()
			$lives.lives = 7
			$lives.loseLife()
	
	if self.position.y > target.y and stage == 3:
		self.position.y -= SPEED * delta
		if self.position.y < target.y:
			self.position.y = target.y
	
	if Input.is_action_just_pressed("r") and stage == 0:
		$lives.lives = 7
		$lives.loseLife()
		$title.visible = false
		get_parent().get_node("spawner").active = true
		get_parent().get_node("spawner").reset()
		$score.addScore(-$score.score)
		
		stage = 1
		
		for N in get_parent().get_children():
			if N is boobyTrap:
				N.currentStage = stage
		
		print(stage)
		target = Vector2(54, 40 + 80)
	
	if Input.is_action_just_pressed("r") and stage == 3:
		$title.rect_position.y = -35
		$title.bbcode_text = "[center]DON'T LET THEM\nTHROUGH\n[b]press r[/b][/center]"
		self.position = Vector2(54, 40)
		stage = 0

func _on_lives_allLivesLost():
	if stage == 2:
		$title.rect_position.y = -15
		$title.bbcode_text = "[center]GAME OVER\n[b]press r[/b][/center]"
		$title.visible = true
		stage = 3
		target = Vector2(54, 40)
		
		for N in get_parent().get_children():
			if N is boobyTrap:
				N.currentStage = stage
			if N is Player:
				N.queue_free()
		target = Vector2(54, 40 + 80)
		
		get_parent().get_node("spawner").active = false
		
		$profondeur.text = str(-100) + "m"
	
	if stage == 1:
		stage = 2
		for N in get_parent().get_children():
			if N is boobyTrap:
				N.currentStage = stage
			if N is Player:
				N.die()
		target = Vector2(54, 40 + 80)

		$profondeur.text = str(-100*stage) + "m"
		get_parent().get_node("spawner").active = false
	
	


func _on_music_finished():
	get_parent().get_node("music").play()
