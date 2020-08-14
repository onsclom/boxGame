extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera
var player
var timeOnLevel = 0

var curLevel = []

var curScene = null

var testPlay = preload("res://PlayTest.tscn")
var editor = preload("res://LevelEditor.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeOnLevel += delta
	pass

func playTest():
	curScene.get_tree().change_scene_to(testPlay)
	
func toEditor():
	curScene.get_tree().change_scene_to(editor)
