extends boobyTrap

var projectileScene = preload("res://scenes/projectile.tscn")
var projectileChild

var sound = preload("res://sound/shoot.wav")

func _ready():
	type = "shootTrap"
	_set_sprite()
	_set_rate()
	
	$sound.stream = sound

func _attack():
	projectileChild = projectileScene.instance()
	
	$sound.play()
	 
	self.add_child(projectileChild)
