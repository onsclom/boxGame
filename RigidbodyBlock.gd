extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2(0,0)
var gravity = 10
const MAX_FALL_SPEED = 100
var held = false
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bodies")
	pass # Replace with function body.

func _physics_process(delta):
	if held:
		$CollisionShape2D.disabled=true
		$Sprite.z_index = 1
		$Sprite.modulate.a = .3
		return
	$Sprite.modulate.a = 1
		
	$CollisionShape2D.disabled=false
	$Sprite.z_index = 0
	
	velocity.y += gravity
	
	velocity.y = min(velocity.y, MAX_FALL_SPEED)
	
	var grounded = ($GroundCheck.is_colliding() or $GroundCheck2.is_colliding())
	
	if grounded:
		velocity.x = lerp(velocity.x, 0, .1)
		
	if is_on_floor():
		velocity.y = min(velocity.y, 0)
		
	var snap = Vector2.ZERO
	velocity = move_and_slide_with_snap( velocity, snap , Vector2(0,-1) )
	#move_and_slide(velocity*delta, Vector2(0,-1)).y * (1/delta)
	
	var push = 5
	
	if grounded:
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.is_in_group("bodies"):
				var box = collision.get_collider()
				
				if (collision.normal) != Vector2(0,-1):
					box.velocity += -collision.normal * push

	
