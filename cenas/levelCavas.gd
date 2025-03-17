extends Label

var player

func _ready():
	player = GameManager.player
	
func _process(delta):
	var level = player.level
	text = "level:  %s" % str(level)
	pass
