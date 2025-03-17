extends Node

@export var node : Node # = $"../../sequir"

func _process(delta):
	var conta: Vector2 = GameManager.conta_sequir_jogador
	# print(player_position)
	var sprit = get_parent()
	
	if conta:
		
		if node.conta.x > 0:
			sprit.flip_h = false
			
		if node.conta.x < 0:
			sprit.flip_h = true

