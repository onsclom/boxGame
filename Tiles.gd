extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blockScenes = [preload("res://block.tscn"), preload("res://RigidbodyBlock.tscn"), preload("res://KeyBlock.tscn"), preload("res://Key.tscn"), preload("res://Character.tscn")]
onready var block = preload("res://block.tscn")
onready var rigidblock = preload("res://RigidbodyBlock.tscn")
var blocks = []
var blockAmount = 16
var blockSize = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	makeLevel()
	pass
					
func makeLevel():
	for child in get_children():
		child.queue_free()
	
	blocks = GameManager.curLevel
					
	for x in range(blockAmount):
		for y in range(blockAmount):
			if blocks[x][y] == 1:
				var newBlock = block.instance()
				add_child(newBlock)
				newBlock.global_position = Vector2(blockSize*x+.5*blockSize, blockSize*y+.5*blockSize)
	#
				var neighbors =  [Vector2(x+1,y),Vector2(x-1,y),Vector2(x,y+1),Vector2(x,y-1)]
				var side = 0
				for neighbor in neighbors:
					if neighbor.x >= 0 and neighbor.x < blockAmount and neighbor.y >= 0 and neighbor.y < blockAmount:
						#print(neighbor.x, neighbor.y)
						if blocks[neighbor.x][neighbor.y] == 1:
							newBlock.sides[side].visible = false
					side += 1
			elif blocks[x][y] > 1:
				var newBlock = blockScenes[blocks[x][y]-1].instance()
				add_child(newBlock)
				newBlock.global_position = Vector2(blockSize*x+.5*blockSize, blockSize*y+.5*blockSize)
					
					
func _process(delta):
	if Input.is_action_just_pressed("refresh"):
		makeLevel()
	pass
