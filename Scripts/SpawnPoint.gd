extends Marker2D

@export var platform: PackedScene

var currentPlatform = null
var spawnNext = false

func _ready():
	pass
	
func SpawnPlatform():
	currentPlatform = platform.instance()
	get_parent().add_child(currentPlatform)
	currentPlatform.global_position = global_position

func on_spawn_timer_timeout():
	pass
