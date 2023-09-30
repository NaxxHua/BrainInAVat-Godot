extends CanvasLayer


@onready var player = get_node("../Player")

func _ready():
	pass
	
func _physics_process(delta):
	$coinText.text = String(player.coinCount)
	
