extends KinematicBody2D

const MOVE_SPEED = 75
const JUMP_FORCE = 200
const GRAVITY = 10
const MAX_FALL_SPEED = 200
const MAX_SLIDE_SPEED = 35
const doubleJumpBug = true

var y_velo = 0
var facing_right = false
var coyoteTime = .1

var wallJumpVel = 0
var wallJumpTime = 0
var wallJumpPenaltyTime = .355
var jumpRememberTime = .2

var timeSinceGrounded = 0
var jumpedLast = jumpRememberTime


onready var sprite = $AnimatedSprite
var rotationAmount = 15
var rotationDir = 0
var rotationChangeSpeed = 1
var rotationGoal = 0

var maxFallSpeed = 200
var maxSquish = .65

var squashedTotalTime = .25
var squashedTime = squashedTotalTime

var prevYvelo = 0

func _ready():
	#AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	pass 
	
func _physics_process(delta):
	
	var grounded = is_on_floor()
	
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	
	if grounded and move_dir != 0:
		$AnimatedSprite.play("walking")
		if !$Walking.playing:
			$Walking.play()
	elif timeSinceGrounded > .05 or move_dir == 0:
		$Walking.stop()
		$AnimatedSprite.play("default")
		
	rotationGoal = move_dir*rotationAmount
	$AnimatedSprite.rotation_degrees = rotationGoal
	
	if wallJumpTime < wallJumpPenaltyTime and grounded == false and wallJumpVel != 0:
		move_dir = wallJumpVel
	 
	var result = move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1))
	
	if doubleJumpBug == false:
		grounded = is_on_floor()
	
	y_velo = result.y
	if result.x == 0 and wallJumpVel != 0:
		wallJumpVel = 0
	
	if timeSinceGrounded > .05:
		$AnimatedSprite.play("jumping")
		
	
#	if (!grounded and timeSinceGrounded ==0) or timeSinceGrounded >= 0:
#		timeSinceGrounded += delta
	if grounded:
		timeSinceGrounded = 0
	else:
		timeSinceGrounded += delta
	
	y_velo += GRAVITY

	if (grounded or timeSinceGrounded < coyoteTime) and (Input.is_action_just_pressed("jump") or jumpedLast < jumpRememberTime):
		$JumpParticles.restart()
		$JumpParticles.emitting = true
		y_velo = -JUMP_FORCE
		timeSinceGrounded = 100
		jumpedLast = jumpRememberTime+1
		$Jumping.playing = true
	elif ($Left.is_colliding() or $Left2.is_colliding()) and (Input.is_action_just_pressed("jump") or jumpedLast < jumpRememberTime):
		$LeftWallJump.restart()
		$LeftWallJump.emitting=true
		y_velo = -JUMP_FORCE
		wallJumpVel = 1
		wallJumpTime = 0
		timeSinceGrounded = coyoteTime+1
		jumpedLast = jumpRememberTime+1
		$Jumping.playing = true
		
	elif ($Right.is_colliding() or $Right2.is_colliding()) and (Input.is_action_just_pressed("jump") or jumpedLast < jumpRememberTime):
		$RightWallJump.restart()
		$RightWallJump.emitting=true
		y_velo = -JUMP_FORCE
		wallJumpVel = -1
		wallJumpTime = 0
		timeSinceGrounded = coyoteTime+1
		jumpedLast = jumpRememberTime+1
		$Jumping.playing = true
		
	elif Input.is_action_just_pressed("jump"):
		jumpedLast = 0
		timeSinceGrounded = coyoteTime
		
	jumpedLast += delta
		
	wallJumpTime += delta
		
#	if ($Left.is_colliding() or $Left2.is_colliding()) and wallJumpVel == -1:
#		wallJumpVel = 0
#	elif ($Right.is_colliding() or $Right2.is_colliding()) and wallJumpVel == 1:
#		wallJumpVel = 0
	if grounded:
		wallJumpVel = 0
		
		
	if y_velo <= 0 and Input.is_action_just_released("jump"):
		y_velo /= 2.0
		pass
	if grounded and y_velo >= 1:
		y_velo = 1
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
		
	var scaleAmount = max( range_lerp(y_velo, 0, 200, 1, maxSquish), .8)
	$AnimatedSprite.scale.x = scaleAmount
	
	$LeftParticles.emitting = false
	$RightParticles.emitting = false
	if !grounded and timeSinceGrounded>.05 and Input.is_action_pressed("move_left"):
		if $Left.is_colliding() or $Left2.is_colliding():
				$LeftParticles.emitting = true
				y_velo = min(y_velo, MAX_SLIDE_SPEED)
				
				if $Sliding.stream_paused and y_velo >= MAX_SLIDE_SPEED:
					$Sliding.stream_paused = false
		else:
			if not $Sliding.stream_paused:
					$Sliding.stream_paused = true
	elif !grounded and timeSinceGrounded>.05 and Input.is_action_pressed("move_right"):
		if $Right.is_colliding() or $Right2.is_colliding():
				$RightParticles.emitting = true
				y_velo = min(y_velo, MAX_SLIDE_SPEED)
				
				if $Sliding.stream_paused and y_velo >= MAX_SLIDE_SPEED:
					$Sliding.stream_paused = false
		else:
			if not $Sliding.stream_paused:
					$Sliding.stream_paused = true
	else:
		if not $Sliding.stream_paused:
					$Sliding.stream_paused = true
				
	if prevYvelo>= 100 and ( $GroundCheck.is_colliding() or $GroundCheck2.is_colliding() ):
		$JumpParticles.restart()
		$JumpParticles.emitting = true	
		if not $Landing.playing:
			$Landing.play()
			squashedTime = 0
			
	prevYvelo = y_velo
	
	$WalkParticles.emitting = false
	if move_dir != 0 and (grounded):
		$WalkParticles.emitting = true
		
	squashedTime += delta
	if squashedTime < squashedTotalTime:
		$AnimatedSprite.scale.x = 1.3
	
#	if grounded:
#		if move_dir == 0:
#			play_anim("idle")
#		else:
#			play_anim("walk")
#	else:
#		play_anim("jump")
