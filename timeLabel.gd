extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bbcode_text = "[right]time:\n" + formatTime(GameManager.timeOnLevel) + "[/right]"

func formatTime(inputTime):
	var minutes = int(inputTime) / 60
	var seconds = int(inputTime) % 60
	seconds = str(seconds)

	#add digit 0 to seconds when necessary
	return str(minutes) + ":" + (seconds if seconds.length()==2 else "0"+seconds)
