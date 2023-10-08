extends CharacterBody2D

var speed = 250
var maxSpeed = 500
var jump = 150
var jumpCount = 0

var wallJump = -40

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 300

const FRICTION = 0.70

@export var HurtScene: PackedScene

var canSlash = false

var lives = 3
var coinCount = 0


#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = jump
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * speed
#	else:
#		velocity.x = move_toward(velocity.x, 0, speed)
#
#	move_and_slide()

func _process(delta):
	var movement = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if movement != 0 && canSlash == false:
		velocity.x += movement * maxSpeed * delta
#		velocity.x = movement * speed
		velocity.x = clamp(velocity.x, -speed, speed)
		$anim.flip_h = movement < 0
		if $anim.flip_h == true:
			$Sword.position.x = -17
		elif $anim.flip_h == false:
			$Sword.position.x = 15
		$anim.play("Walk")
	elif velocity.x == 0 && velocity.y < 0 && canSlash == false:
		$anim.play("Jump")
	# For small jump 30 is good but for bigger jump consider 60
	elif velocity.x == 0 && velocity.y > 30 && canSlash == false:
		$anim.play("Fall")
	elif movement == 0 && canSlash == false:
		velocity.x = lerp(velocity.x, 0.0, FRICTION)
		$anim.play("Idle")
	
	if velocity.y > 350:
		get_tree().reload_current_scene()
	
	if is_on_floor() or nextToWall():
		jumpCount = 0
	if Input.is_action_just_pressed("ui_accept") && jumpCount < 2:
		jumpCount += 1
		velocity.y -= clamp(velocity.y, jump, jump)
	if Input.is_action_just_pressed("ui_accept"):
		if !is_on_floor() && RightWall():
			velocity.y = clamp(velocity.y, wallJump, wallJump)
		elif !is_on_floor() && LeftWall():
			velocity.y = clamp(velocity.y, wallJump, wallJump)
		
	if Input.is_action_just_pressed("ui_accept") && jumpCount > 2:
		jumpCount = 0
	if !is_on_floor() && Input.is_action_just_pressed("ui_accept") && canSlash == false && jumpCount < 2:
		velocity.y -= clamp(velocity.y, jump, jump)
		$anim.play("Jump")
	elif !is_on_floor() && velocity.y < 0 && velocity.x != 0 && canSlash == false:
		$anim.play("Jump")
	elif !is_on_floor() && velocity.y >0 && velocity.x != 0 && canSlash == false:
		$anim.play("Fall")
		
	if Input.is_action_just_pressed("ui_sword"):
		canSlash = true
		$Sword/CollisionShape2D.disabled = false
		$anim.play("Sword")
		if is_on_floor() && canSlash == true:
			$anim.play("Sword")
		elif velocity.y < 0 && velocity.x != 0 && canSlash == true:
			$anim.play("Sword")
		elif velocity.y > 0 && velocity.x != 0 && canSlash == true:
			$anim.play("Sword")
	
	velocity.y += gravity * delta
	move_and_slide()
	
func hurt():
	lives -= 0.25
	var red = HurtScene.instantiate()
	add_child(red)
	print("Player has enetered", lives)
	if lives <= 0:
		get_tree().reload_current_scene()
	if velocity.x >= 0:
		velocity.y = -73
		velocity.x = -73
	elif velocity.x <= 0:
		velocity.y = -73
		velocity.x = 73

func nextToWall():
	return RightWall() or LeftWall()

func RightWall():
	return $RightWall.is_colliding()

func LeftWall():
	return $LeftWall.is_colliding()
		
func coinPickup():
	coinCount += 1
	print(coinCount)


func _on_anim_animation_finished():
	if $anim.animation == "Sword":
		canSlash = false
		$Sword/CollisionShape2D.disabled = true
