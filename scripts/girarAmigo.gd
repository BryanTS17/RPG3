extends Node

@export var node : Node2D # = $"../../sequir"

func _process(delta):
	# print(player_position)
	var sprit = get_parent()
	
	
	if node.conta:
		
		if (node.conta.x * -1) > 0:
			sprit.flip_h = false
			
		if (node.conta.x * -1) < 0:
			sprit.flip_h = true


