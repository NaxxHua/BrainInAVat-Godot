extends Area2D

var lives = 3

func _on_area_entered(area):
	if area.is_in_group("Sword"):
		lives -= 1
		$anim.play("Slashed")
		await $anim.animation_finished
		$anim.play("Active")
		if lives <= 0:
			$anim.play("Destroyed")
			await $anim.animation_finished
			queue_free()
