extends Node2D

class_name PowderObj

# 1 Sand -- 2 Block -- 3 Blood -- 4 Lava -- 5 Smoke
var id : int = 1 
var color : Color
var next_position = null

var liquidSide = 0

var lifeSpan = randi() % 500

var lifeActual = 0

func setColor():
	lifeActual = 0
	
	if id == 1:
		color = Color("#2aa4aa")
	
	if id == 2:
		color = Color(0,0,0,0)
		lifeSpan = -1
	
	if id == 3:
		color = Color("#41de95")
	
	if id == 4:
		color = Color("#c4651c")
		lifeSpan = -1
	
	if id == 5:
		color = Color("#747d88")
		lifeSpan = randi() % 50 + 1
	
	$sprite.modulate = color


func powderUpdate(grid):
	
	var mvtMatrix
	
	if id == 1:
		
		mvtMatrix = [0, 0, 0]
		
		if grid[self.position.y + 1][self.position.x] != null:
			mvtMatrix[0] += 1
			
			if grid[self.position.y + 1][self.position.x].id == 4 or grid[self.position.y + 1][self.position.x].id == 5:
				self.id = 5
				setColor()
			
		if grid[self.position.y + 1][self.position.x + 1] != null:
			mvtMatrix[1] += 1
			
			if grid[self.position.y + 1][self.position.x + 1].id == 4 or grid[self.position.y + 1][self.position.x + 1].id == 5:
				self.id = 5
				setColor()
			
		if grid[self.position.y + 1][self.position.x - 1] != null:
			mvtMatrix[2] += 1
		
			if grid[self.position.y + 1][self.position.x - 1].id == 4 or grid[self.position.y + 1][self.position.x - 1].id == 5:
				self.id = 5
				setColor()
		
		
		var idx = 0
		for pos in mvtMatrix:
			if pos == 0:
				if idx == 0:
					next_position = self.position + Vector2(0, 1)
					return
				if idx == 1:
					next_position = self.position + Vector2(1, 1)
					return
				if idx == 2:
					next_position = self.position + Vector2(-1, 1)
					return
			idx += 1
	
	if id == 5:
		
		mvtMatrix = [0, 0, 0]
		
		if grid[self.position.y - 1][self.position.x] != null:
			mvtMatrix[0] += 1
		if grid[self.position.y - 1][self.position.x + 1] != null:
			mvtMatrix[1] += 1
		if grid[self.position.y - 1][self.position.x - 1] != null:
			mvtMatrix[2] += 1
		
		
		var idx = 0
		for pos in mvtMatrix:
			if pos == 0:
				if idx == 0:
					next_position = self.position + Vector2(0, -1)
					return
				if idx == 1:
					next_position = self.position + Vector2(1, -1)
					return
				if idx == 2:
					next_position = self.position + Vector2(-1, -1)
					return
			idx += 1
	
	if id == 4 or id == 3:
		
		mvtMatrix = [0, 0, 0, 0, 0]
		
		
		if grid[self.position.y + 1][self.position.x] != null:
			mvtMatrix[0] += 1
		if grid[self.position.y + 1][self.position.x + 1] != null:
			mvtMatrix[1] += 1
		if grid[self.position.y + 1][self.position.x - 1] != null:
			mvtMatrix[2] += 1
		
		if liquidSide == 0:
			if grid[self.position.y][self.position.x + 1] != null:
				mvtMatrix[3] += 1
			if grid[self.position.y][self.position.x - 1] != null:
				mvtMatrix[4] += 1
		
		if liquidSide == 1:
			if grid[self.position.y][self.position.x - 1] != null:
				mvtMatrix[3] += 1
			if grid[self.position.y][self.position.x + 1] != null:
				mvtMatrix[4] += 1
		
		var idx = 0
		for pos in mvtMatrix:
			if pos == 0:
				if idx == 0:
					next_position = self.position + Vector2(0, 1)
					return
				if idx == 1:
					next_position = self.position + Vector2(1, 1)
					return
				if idx == 2:
					next_position = self.position + Vector2(-1, 1)
					return
				
				if liquidSide == 0:
					if idx == 3:
						next_position = self.position + Vector2(1, 0)
						return
					if idx == 4:
						next_position = self.position + Vector2(-1, 0)
						liquidSide = 1
						return
				
				if liquidSide == 1:
					if idx == 3:
						next_position = self.position + Vector2(-1, 0)
						return
					if idx == 4:
						next_position = self.position + Vector2(1, 0)
						liquidSide = 0
						return
				
			idx += 1
		
	
	next_position = null
