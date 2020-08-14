extends Node2D

var type = 0
onready var sides = [$Right, $Left, $Down, $Up]
onready var animations = ["Nothing","NormalBlock", "PhysicsBlock","KeyBlock","Key","Player"]

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if type < animations.size():
		$AnimatedSprite.animation = animations[type]
	pass
