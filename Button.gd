extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var num = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_down", self, "buttonPressed")
	
func buttonPressed():
	get_parent().buttonClicked(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
