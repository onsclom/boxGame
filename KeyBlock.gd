extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var activated = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("KeyBlocks")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	print(body)
	if body.name=="Character" and body.hasKey and not activated:
		body.hasKey = false
		body.key.queue_free()
		
		detectAndRemove()

func detectAndRemove():
	if activated == true:
		return
	
	activated = true
	
	$StaticBody2D.collision_layer = 0
	$StaticBody2D.collision_mask = 0
	$Sprite.visible = false
	$key.visible = false
	
	$CPUParticles2D.emitting = true
	
	GameManager.camera.set_trauma(1.0)

	yield(get_tree().create_timer(.5), "timeout")	
		
	for keyblock in get_tree().get_nodes_in_group("KeyBlocks"):
		if global_position.distance_to(keyblock.global_position) <= 16:
			keyblock.detectAndRemove()
	yield(get_tree().create_timer(.5), "timeout")	
	queue_free()
