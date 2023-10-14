extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		await get_tree().create_timer(0.5).timeout
		$anim.play("Destroyed")
		await $anim.animation_finished
		queue_free()
