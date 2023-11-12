extends CanvasLayer

@onready var player = get_node("../Player")

const HEART_ROW_SIZE = 8
const HEART_OFFSET = 16

func _ready():
	for i in player.lives:
		var new_heart = Sprite2D.new()
		new_heart.texture = $Heart.texture
		new_heart.hframes = $Heart.hframes
		$Heart.add_child(new_heart)
		
	
func _physics_process(_delta):
	$coinText.text = str(player.coinCount)
	
	for heart in $Heart.get_children():
		var index = heart.get_index()
		
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET * 1.0
		heart.position = Vector2(x, y)
		
		var lastHeart = floor(player.lives)
		if index > lastHeart:
			heart.frame = 0
		if index == lastHeart:
			heart.frame = (player.lives - lastHeart) * 4
		if index < lastHeart:
			heart.frame = 4
