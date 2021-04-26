extends boobyTrap

var pillarScene = preload("res://scenes/pillar.tscn")
var pillarChild

var sound = preload("res://sound/pillar.wav")

func _ready():
	type = "pillarTrap"
	_set_sprite()
	_set_rate()
	$sound.stream = sound

func _attack():
	pillarChild = pillarScene.instance()
	pillarChild.position.y -= 10 
	self.add_child(pillarChild)
