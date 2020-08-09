extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2(0,0)
var gravity = 10
const MAX_FALL_SPEED = 200
var held = false
var grounded = false
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
	
	grounded = ($GroundCheck.is_colliding() or $GroundCheck2.is_colliding())
	
	if grounded:
		velocity.x = lerp(velocity.x, 0, .1)
		velocity.y = min(velocity.y, 0)
	

		
	var snap = Vector2.DOWN * 1 if grounded else Vector2.ZERO
	#snap = Vector2.ZERO
	#snap = Vector2.ZERO
	velocity = move_and_slide(velocity, Vector2(0,-1), false, 20 )
	#move_and_slide(velocity*delta, Vector2(0,-1)).y * (1/delta)
	
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			var box = collision.get_collider()
			
			
			box.velocity.x += -collision.normal.x*abs(velocity.x/50)
			#box.velocity.y = velocity.y
			#parent = collision.collider
	
