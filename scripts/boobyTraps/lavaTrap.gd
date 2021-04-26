extends boobyTrap

var lavaFloorScene = preload("res://scenes/lavaFloor.tscn")
var lavaFloorChild

var sound = preload("res://sound/lava.wav")

func _ready():
	type = "lavaTrap"
	
	$collisionBox.queue_free()
	
	_set_sprite()
	_set_rate()
	
	get_parent().get_node("powderToy").add_lava(self.position, true)
	
	$sound.stream = sound
	
	makeFloor()

func makeFloor():
	var a = lavaFloorScene.instance()
	
	a.position.y += -5
	
	add_child(a)
	
	lavaFloorChild = a

func _attack():
	lavaFloorChild.queue_free()
	$sprite.frame = 1
	
	$sound.play()
	
	yield(get_tree().create_timer(3), "timeout")
	
	makeFloor()
	$sprite.frame = 0
