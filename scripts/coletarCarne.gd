extends Area2D

@export var coletar: CollisionShape2D
@export var coletado: PackedScene

func _process(delta):
	var corpos = get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("player"):
			body.coletarCarne(20)
			var carne = coletado.instantiate()
			carne.position = position
			get_parent().add_child(carne)
			queue_free()
	pass
