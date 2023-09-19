extends Area2D

var coinScene = preload("res://Prefabs/Items/coin.tscn")

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
			onDestroyed()
			queue_free()

func onDestroyed():
	var coin = coinScene.instantiate()
	coin.global_transform.origin = global_transform.get_origin()
	get_tree().get_root().add_child(coin)
