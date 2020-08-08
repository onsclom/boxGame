extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var firstMod = $CanvasModulate
onready var secondMod = get_node("UI stuff/CanvasModulate")

export var sat = .1
export var v = 1
var h

var time = 0
var timeSinceGrounded = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var newColor = Color.from_hsv(sin(time/8.0)/2.0+.5, sat, v )
	firstMod.color = newColor
	secondMod.color = newColor

func set_velocity(test):
	print("wow")
