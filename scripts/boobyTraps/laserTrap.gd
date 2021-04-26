extends boobyTrap

var laserScene = preload("res://scenes/laser.tscn")
var laserChild

var sound = preload("res://sound/laser.wav")

func _ready():
	type = "laserTrap"
	$sound.stream = sound
	_set_sprite()
	_set_rate()

func _attack():
	laserChild = laserScene.instance()
	laserChild.connect("laserToggle", self, "activateLaserKillzone")
	laserChild.position.x -= 29
	self.add_child(laserChild)
	$sound.play()

func activateLaserKillzone():
	$killzone.active = !$killzone.active
