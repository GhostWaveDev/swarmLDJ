extends Node2D

signal laserToggle

func _ready():
	$sprite.play()

func _on_sprite_animation_finished():
	self.queue_free()

func _on_sprite_frame_changed():
	if $sprite.frame == 2:
		emit_signal("laserToggle")
	if $sprite.frame == 10:
		emit_signal("laserToggle")
