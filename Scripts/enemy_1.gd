extends CharacterBody2D

var coinScene = preload("res://Prefabs/Items/coin.tscn")

var speed = 40
const JUMP_VELOCITY = -400.0
var direction = Vector2.RIGHT

var lives  = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 500

func _ready():
	$PathDetector.connect("area_entered", Callable(self, "onPathEntered"))
	
func onPathEntered(_area2d):
	direction *= -1

func _process(delta):
	velocity.x = direction.x * speed
	
	if lives <= 0:
		velocity = Vector2.ZERO
	
	velocity.y += gravity * delta
	move_and_slide()
	
	$Sprite2D.flip_h = true if direction.x < 0 else false


func _on_hit_box_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()


func _on_hit_box_area_entered(area):
	if area.is_in_group("Sword"):
		lives -= 1
		$anim.play("Hurt")
		await $anim.animation_finished
		$anim.play("Run")
		if lives <= 0:
			$anim.play("Dead")
			await $anim.animation_finished
			onDestroyed()
			queue_free()

func onDestroyed():
	var coin = coinScene.instantiate()
	coin.global_transform.origin = global_transform.get_origin()
	get_tree().get_root().add_child(coin)
