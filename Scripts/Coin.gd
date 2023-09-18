extends Area2D



func _on_body_entered(body):
	if body.has_method("coinPickup"):
		body.coinPickup()
		$anim.play("Picked")
		await get_tree().create_timer(0.3).timeout
		queue_free()
