extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tile = preload("res://Tile.tscn")
var blocks = []
var blockAmount = 16
var blockSize = 16

var curType = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	makeLevel(0)
	pass
					
func makeLevel(rngAmount):
	for child in get_children():
		if child.name != "Indicator":
			child.queue_free()
	
	blocks = []

	for x in range(blockAmount):
		blocks.append([])
		for y in range(blockAmount):
			var newTile = tile.instance()
			newTile.position = Vector2(x*blockSize+blockSize*.5, y*blockSize+blockSize*.5)
			add_child(newTile)
			blocks[x].append(newTile)
			
			if x==0 or x==blockAmount-1 or y==0 or y==blockAmount-1:
				blocks[x][y].type = 1
			else:
				blocks[x][y].type = 0
				
	if GameManager.curLevel != []:
		for x in range(blockAmount):
			for y in range(blockAmount):
				blocks[x][y].type = GameManager.curLevel[x][y]
					
	for x in range(blockAmount):
		for y in range(blockAmount):
			if blocks[x][y].type == 1:
				var neighbors =  [Vector2(x+1,y),Vector2(x-1,y),Vector2(x,y+1),Vector2(x,y-1)]
				var side = 0
				for neighbor in neighbors:
					if neighbor.x >= 0 and neighbor.x < blockAmount and neighbor.y >= 0 and neighbor.y < blockAmount:
						#print(neighbor.x, neighbor.y)
						if blocks[neighbor.x][neighbor.y].type != 1:
							blocks[x][y].sides[side].visible = true
					else:
						blocks[x][y].sides[side].visible = true
					side += 1

func _process(delta):
	
	#better way to do this maybe?
	var newLevel = []
	for x in range(blockAmount):
		newLevel.append([])
		for y in range(blockAmount):
			newLevel[x].append(blocks[x][y].type)
	GameManager.curLevel = newLevel
			
	
	if Input.is_action_just_pressed("refresh"):
		makeLevel(.1)
	
	#lets get mouse x and y in terms of grid
	var mousePos = Vector2(get_local_mouse_position().x/blockSize,get_local_mouse_position().y/blockSize)
	mousePos = Vector2(floor(mousePos.x),floor(mousePos.y))
	
	if mousePos.x > 0 and mousePos.x < blockAmount-1 and mousePos.y > 0 and mousePos.y < blockAmount-1:
		$Indicator.visible = true
		$Indicator.position = Vector2(mousePos.x * blockSize + blockSize*.5, mousePos.y * blockSize + blockSize*.5)
		
		if Input.is_action_pressed("left_click"):
			#left places
			if blocks[mousePos.x][mousePos.y].type != curType:
				placeBlock(mousePos, curType)
		if Input.is_action_pressed("right_click"):
			#right deletes
			if blocks[mousePos.x][mousePos.y].type != 0:
				placeBlock(mousePos, 0)
		
	else:
		$Indicator.visible = false
		
func updateSides(spot):
	if blocks[spot.x][spot.y].type == 1:
		print("is 1")
		var neighbors = [Vector2(spot.x+1,spot.y),Vector2(spot.x-1,spot.y),Vector2(spot.x,spot.y+1),Vector2(spot.x,spot.y-1)]
		var side = 0
		for neighbor in neighbors:
			if neighbor.x >= 0 and neighbor.x < blockAmount and neighbor.y >= 0 and neighbor.y < blockAmount:
				#print(neighbor.x, neighbor.y)
				if blocks[neighbor.x][neighbor.y].type != 1:
					blocks[spot.x][spot.y].sides[side].visible = true
				else:
					blocks[spot.x][spot.y].sides[side].visible = false
			else:
				blocks[spot.x][spot.y].sides[side].visible = true
			side += 1 

func placeBlock(spot, type):
	print("test")
	blocks[spot.x][spot.y].type = type
	
	#if its default block, update autotile
	updateSides(spot)
	var neighbors = [Vector2(spot.x+1,spot.y),Vector2(spot.x-1,spot.y),Vector2(spot.x,spot.y+1),Vector2(spot.x,spot.y-1)]
	for neighbor in neighbors:
		if neighbor.x >= 0 and neighbor.x < blockAmount and neighbor.y >= 0 and neighbor.y < blockAmount:
			print(neighbor)
			updateSides(neighbor)
	
	#if its the player, make sure it's only placed once
	
	#if its anything besides default block, make sure to unvisible all sides
	if type != 1:
		for side in blocks[spot.x][spot.y].sides:
			side.visible = false
	else:
		pass
		#update neighbors 
