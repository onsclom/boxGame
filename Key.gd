extends Area2D

var y_pos
var runningTime = 0
var taken = false
var charRef = null
var keySide = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not taken:
		runningTime += delta
		$Sprite.position = Vector2(0.0,sin(runningTime*4)*1.5)
	else:
		if charRef == null:
			return
		#check side of player for key
		# and lerp to that position
		if (charRef.move_dir == 1):
			keySide = -1
		elif (charRef.move_dir == -1):
			keySide = 1
			
		if keySide == -1:
			$Sprite.global_position =  $Sprite.global_position*.9 + charRef.get_node("LeftKey").global_position*.1
		else:
			$Sprite.global_position = $Sprite.global_position*.9 + charRef.get_node("RightKey").global_position*.1

func _on_Key_body_entered(body):
	if body.name == "Character" and taken == false and body.hasKey == false:
		body.hasKey = true
		charRef = body
		taken = true
		body.key = self
		$HitParticles.emitting = true
		$CollisionShape2D.disabled = true
		

		
