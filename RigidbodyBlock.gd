extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2(0,0)
var gravity = 10
const MAX_FALL_SPEED = 200
var held = false
var grounded = false

var timeSinceGrounded = 0
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


	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, .1)
		velocity.y = min(0,velocity.y)

	
	var snap = Vector2.DOWN * 1 if grounded else Vector2.ZERO
	#snap = Vector2.ZERO
	#snap = Vector2.ZERO
	var prevVelo = velocity
	velocity = move_and_slide(velocity, Vector2(0,-1), false, 20 )
	
	#move_and_slide(velocity*delta, Vector2(0,-1)).y * (1/delta)
	
	$Sliding.emitting = false
	$Sliding2.emitting = false
	if is_on_floor() and abs(velocity.x)>1:
		if $GroundCheck.is_colliding():
			$Sliding.emitting = true
		elif $GroundCheck2.is_colliding():
			$Sliding2.emitting = true
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		var strength = (collision.normal*prevVelo).length_squared()
		if strength > 1000:
			GameManager.camera.add_trauma(.003*sqrt(strength))

			if collision.normal == Vector2(0,-1):
				$BottomParticles.restart()
				$BottomParticles.emitting=true
			elif collision.normal == Vector2(0,1):
				$Up.restart()
				$Up.emitting=true
			elif collision.normal == Vector2(1,0):
				$Left.restart()
				$Left.emitting=true
			elif collision.normal == Vector2(-1,0):
				$Right.restart()
				$Right.emitting=true
			
				
		if collision.collider.is_in_group("bodies"):
			var box = collision.get_collider()
			
			box.velocity.x += -collision.normal.x*abs(velocity.x/50)
			#box.velocity.y = velocity.y
			#parent = collision.collider
	if !held:			
		$Sprite.global_position = Vector2(round(global_position.x),round(global_position.y))
