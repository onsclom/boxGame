extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cur = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pressed = false
	if Input.is_key_pressed(KEY_1):
		cur = 1
		pressed = true
	elif Input.is_key_pressed(KEY_2):
		cur = 2
		pressed = true
	elif Input.is_key_pressed(KEY_3):
		cur = 3
		pressed = true
	elif Input.is_key_pressed(KEY_4):
		cur = 4
		pressed = true
	elif Input.is_key_pressed(KEY_5):
		cur = 5
		pressed = true
	elif Input.is_key_pressed(KEY_6):
		cur = 6
		pressed = true
		
	if pressed:
		for button in get_children():
			if button.num != cur:
				button.pressed = false
			else:
				button.pressed = true

func buttonClicked(clickedButton):
	for button in get_children():
		if button != clickedButton:
			button.pressed = false
	
	if clickedButton.pressed == false:
		#then nothing should be selected
		cur = clickedButton.num
		print("wow")
	else:
		cur = 0
