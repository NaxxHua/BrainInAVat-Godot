extends CharacterBody2D

var speed = 250
var maxSpeed = 500
var jump = 150

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 300

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
	if movement != 0:
		velocity.x += movement * speed * delta
		$anim.flip_h = movement < 0
		$anim.play("Walk")
	elif velocity.x == 0 && velocity.y < 0:
		$anim.play("Jump")
	# For small jump 30 is good but for bigger jump consider 60
	elif velocity.x == 0 && velocity.y > 30:
		$anim.play("Fall")
	else:
		velocity.x = 0
		$anim.play("Idle")
		
	if is_on_floor() && Input.is_action_just_pressed("ui_accept"):
		velocity.y -= jump
		$anim.play("Jump")
	elif velocity.y < 0 && velocity.x != 0:
		$anim.play("Jump")
	elif velocity.y >0 && velocity.x != 0:
		$anim.play("Fall")
	
	velocity.y += gravity * delta
	move_and_slide()
