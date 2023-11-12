extends Marker2D

@export var platform: PackedScene

var currentPlatform = null
var spawnNext = false

func _ready():
	$SpawnTimer.connect("timeout", Callable(self, "on_spawn_timer_timeout"))
	call_deferred("SpawnPlatform")
	
func SpawnPlatform():
	currentPlatform = platform.instantiate()
	get_parent().add_child(currentPlatform)
	currentPlatform.global_position = global_position
	
func checkPlatform():
	if !is_instance_valid(currentPlatform):
		if spawnNext:
			SpawnPlatform()
			spawnNext = false
		else:
			spawnNext = true

func on_spawn_timer_timeout():
	checkPlatform()



