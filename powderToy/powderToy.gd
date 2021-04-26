extends Node2D

class_name PowderToy

var powderObjScene = preload("res://powdertoy/powderObj.tscn")

var powderGrid = []
var powderToAdd = []

var powderThread

var multiThread = false

var threadDone = true

var saveDataRaw = []

export var MAX_AMOUNT = 400

var data1 = "res://powderData/powderData.save"

func _ready():
	powderThread = Thread.new()
	
	for i in range(0, 81*2):
		var powderGridRow = []
		for j in range(0, 108):
			powderGridRow.append(null)
		powderGrid.append(powderGridRow)
	
	var get_data = load_data(data1)
	
	for vec in get_data:
		add_powder(vec, 2, true)

func _process(delta):
	if Input.is_action_pressed("clivk"):
		add_powder(get_global_mouse_position(), 1)
	
	if Input.is_action_pressed("click_right"):
		add_powder(get_global_mouse_position(), 5)
	
#	if Input.is_action_just_pressed("t"):
#		saveDataRaw = []
#		for row in powderGrid:
#			for obj in row:
#				if obj != null:
#					saveDataRaw.append(obj.position)
#		save_dev(data1, saveDataRaw)

func add_powder(pos, id, override_pos = false):
	var real_pos
	
	if !override_pos:
		real_pos = Vector2(int(pos.x / 7), int(pos.y / 7))
	else:
		real_pos = pos
	
	
	powderToAdd.append([real_pos, id])

func add_body(pos, override_pos = false):
	var real_pos
	
	if !override_pos:
		real_pos = Vector2(int(pos.x / 7), int(pos.y / 7))
	else:
		real_pos = pos
	
	
	#Leg Left
	add_powder(real_pos + Vector2(-3, 0), 1, true)
	add_powder(real_pos + Vector2(-2, -1), 1, true)
	
	#Leg Right
	add_powder(real_pos + Vector2(4, 0), 1, true)
	add_powder(real_pos + Vector2(3, -1), 1, true)
	
	#Body
	add_powder(real_pos + Vector2(-1, -2), 1, true)
	add_powder(real_pos + Vector2(0, -2), 1, true)
	add_powder(real_pos + Vector2(1, -2), 1, true)
	add_powder(real_pos + Vector2(2, -2), 1, true)
	
	add_powder(real_pos + Vector2(-2, -3), 1, true)
	add_powder(real_pos + Vector2(-1, -3), 1, true)
	add_powder(real_pos + Vector2(0, -3), 1, true)
	add_powder(real_pos + Vector2(1, -3), 1, true)
	add_powder(real_pos + Vector2(2, -3), 1, true)
	add_powder(real_pos + Vector2(3, -3), 1, true)
	
	add_powder(real_pos + Vector2(-2, -4), 1, true)
	add_powder(real_pos + Vector2(-1, -4), 1, true)
	add_powder(real_pos + Vector2(0, -4), 3, true)
	add_powder(real_pos + Vector2(1, -4), 1, true)
	add_powder(real_pos + Vector2(2, -4), 3, true)
	add_powder(real_pos + Vector2(3, -4), 1, true)
	
	add_powder(real_pos + Vector2(-2, -5), 1, true)
	add_powder(real_pos + Vector2(-1, -5), 1, true)
	add_powder(real_pos + Vector2(0, -5), 1, true)
	add_powder(real_pos + Vector2(1, -5), 1, true)
	add_powder(real_pos + Vector2(2, -5), 1, true)
	add_powder(real_pos + Vector2(3, -5), 1, true)
	
	add_powder(real_pos + Vector2(-1, -6), 1, true)
	add_powder(real_pos + Vector2(0, -6), 1, true)
	add_powder(real_pos + Vector2(1, -6), 1, true)
	add_powder(real_pos + Vector2(2, -6), 1, true)

func add_lava(pos, override_pos = false):
	var real_pos
	
	if !override_pos:
		real_pos = Vector2(int(pos.x / 7), int(pos.y / 7))
	else:
		real_pos = pos
	
	for i in range(0, 10):
		for j in range(0, 10):
			add_powder(real_pos + Vector2(-5 + i, -5 + j), 4, true)

func updateAll():
	threadDone = false
	
	if multiThread:
		powderThread = Thread.new()
		powderThread.start(self, "hardCalc")
	else:
		hardCalc(0)

func hardCalc(userdata):
	for row in powderGrid:
		for obj in row:
			if obj != null:
				obj.powderUpdate(powderGrid)
	threadDone = true

func _exit_tree():
	powderThread.wait_to_finish()

func _on_calcTimer_timeout():
	if threadDone:
		for row in powderGrid:
			for obj in row:
				if obj != null:
					if obj.next_position is Vector2 and powderGrid[obj.next_position.y][obj.next_position.x] == null:
						powderGrid[obj.position.y][obj.position.x] = null
						
						obj.position = obj.next_position
					
					obj.lifeActual += 1
					
					if obj.position.y < 161:
						powderGrid[obj.position.y][obj.position.x] = obj
					else:
						obj.queue_free()
					
					if obj.lifeSpan == obj.lifeActual:
						obj.queue_free()
						powderGrid[obj.position.y][obj.position.x] = null
		
		for arr in powderToAdd:
			if powderGrid[arr[0].y][arr[0].x] == null:
					var a  = powderObjScene.instance()
					a.position = arr[0]
					a.id = arr[1]
					a.setColor()

					self.add_child(a)
					powderGrid[arr[0].y][arr[0].x] = a
		
		powderToAdd = []
		
	
		updateAll()

	$calcTimer.start()

func save_dev(path, data):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_var(data)
	file.close()

func load_data(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.READ)
		return file.get_var()
		file.close()
	else:
		return 0
