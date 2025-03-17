extends Label

var kills: int = 0
var player

func _ready():
	player = GameManager.player

func _process(delta):
	kills = player.kills
	text = " %s" % str(kills)
	pass

