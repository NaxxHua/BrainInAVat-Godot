extends CharacterBody2D


var speed = 40
const JUMP_VELOCITY = -400.0
var direction = Vector2.RIGHT

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 500

func _ready():
	$PathDetector.connect("area_entered", Callable(self, "onPathEntered"))
	
func onPathEntered(_area2d):
	direction *= -1

func _process(delta):
	velocity.x = direction.x * speed
	
	velocity.y += gravity * delta
	move_and_slide()
	
	$Sprite2D.flip_h = true if direction.x < 0 else false
